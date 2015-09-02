# Program to log resource session info to various files.
#
# Should be supplied at least 2 arguments - input & default output files,
# more output files are allowed as subsequent arguments.
#
# Duplicate session starts & ends without corresponding starts are ignored,
# lines with invalid input & date format are skipped, 
# warnings regarding such ignoring/skipping are also logged 
# to help determine errors in the input file.
#
# Log files can be switched by writing filename to STDIN.
# File switching is realized for large files when there is a reasonable
# amount of time to process.
#
# Usage example: perl sessionManager.pl input.log output1.log output5.log
#
# Modules AnyEvent & DateTime::Format::Strptime are required.
# 
# 2015 Artem Lobanov

use strict;
use warnings;

use DateTime::Format::Strptime;
use AnyEvent;

die("Too few arguments, at least input & default output files should be provided\n") if scalar @ARGV < 2;

my $inputFh = IO::File->new(shift @ARGV, 'r') or die("Cannot open input file, terminating\n");

# Maybe it's worth using hash of filenames/fhs though for this case it seems overhead
my @outputFilenames = @ARGV;
my $curOutputFilename = $outputFilenames[0];
my $curOutputFh = IO::File->new($curOutputFilename, 'a') or 
    die("Cannot open default output file ($outputFilenames[0]), terminating\n");

my $done = AnyEvent->condvar;
my ($process, $commands);

$commands = AnyEvent->io(
    fh => \*STDIN,
    poll => 'r',
    cb => sub {
        chomp (my $input = <STDIN>);
        if ($input =~ /^s|Stop$/) {
            undef $commands;
            undef $process;
            $done->send;
        } elsif (grep (/^$input$/, @outputFilenames)) {
            if ($curOutputFh = IO::File->new("$input", 'w')) {
                $curOutputFilename = $input;
                print "Now writing to file: $curOutputFilename\n";
            } else {
                print "Cannot open file: $input; continuing to write to $curOutputFilename\n";
                if (!($curOutputFh = IO::File->new($curOutputFilename, 'w'))) {
                    print "Cannot continue writing to while file: $curOutputFilename; terminating\n";
                }
            }
        } else {
            print "Invalid filename, continuing to write to $curOutputFilename\n";
        }
    }
);

my $globalSessionId = 1;
my %resourcesInfo;
$process = AnyEvent->io(
   fh => \*$inputFh,
   poll => 'r',
   cb => sub {    
        my $line = $inputFh->getline;
        if ($line) {
            chomp $line;
    
            my $curLineOutputFh = $curOutputFh;
            
            if ($line =~ /(.+) (?:(SYSTEM START)|(?:(\w+): (?:(START)|(STOP)) (?:(STARTED)|(COMPLETE))))/) {
                my $dateString = $1;
                my $sysstart = $2;
                my $resourceName = $3;
                my $start = $4;
                my $stop = $5;
                my $started = $6;
                my $completed = $7;
                
                # DD.MM.YYYY HH:MM:SS
                my $dateFormatting = new DateTime::Format::Strptime(pattern => '%d.%m.%Y%n%T');
                my $date = $dateFormatting->parse_datetime($dateString);
                if (!$date) {
                    $curLineOutputFh->print("Warning: invalid date format, skipping\n");
                    next;
                }
                my $timestamp = $date->epoch();
                
                if ($sysstart) {
                    foreach my $key (keys %resourcesInfo) {
                        $curLineOutputFh->print("$key didn't end\n");
                    }
                    %resourcesInfo = ();
                    $curLineOutputFh->print("Start $globalSessionId:\n");
                    $globalSessionId++;
                } else {
                    my $action = $start ? "start" : "stop";
                    my $key = "$resourceName $action";
                    if ($started) {
                        if ($resourcesInfo{$key}) {
                            $curLineOutputFh->print("Warning: duplication on \"$action started\", ignoring\n");
                        } else {
                            my $inverseAction = $start ? "stop": "start";
                            if ($resourcesInfo{"$resourceName $inverseAction"}) {
                                $curLineOutputFh->print("Warning: $inverseAction didn't complete, but $action has already started\n");
                            }
                            $resourcesInfo{$key} = $timestamp;
                        }
                    } else {
                        my $startedTimestamp = $resourcesInfo{$key};
                        if (!$startedTimestamp) {
                            $curLineOutputFh->print("Warning: \"completed\" was sent before \"started\", ignoring\n");
                        } else {
                            $curLineOutputFh->print(
                                "$resourceName " . ($start ? "started " : "stopped ") . ($timestamp - $startedTimestamp) . " seconds\n");
                            delete($resourcesInfo{$key});
                        }
                    }
                }
            } else {
                $curLineOutputFh->print("Warning: invalid input format, skipping\n");
            }
        } else {
            undef $commands;
            undef $process;
            $done->send;
        }
    }
);

print "Enter files to redirect logging\n";

$done->recv;