using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Windows;
using System.Runtime.Serialization.Formatters.Binary;

namespace PointMapper
{
    class Mapper
    {
        static double delta = 0.5;
        static int divWidth = 7;
        static List<Point>[] pointLists = { new List<Point>(), new List<Point>() };
        static List<List<Point>> pointList1Split = new List<List<Point>>();
        static List<Tuple<Point, Point, Point, Point>> similarSegments = new List<Tuple<Point, Point, Point, Point>>();

        public static object DeepClone(object obj)
        {
            object objResult = null;
            using (MemoryStream ms = new MemoryStream())
            {
                BinaryFormatter bf = new BinaryFormatter();
                bf.Serialize(ms, obj);

                ms.Position = 0;
                objResult = bf.Deserialize(ms);
            }
            return objResult;
        }

        static void ReadCoordList(string filename, List<Point> pointList)
        {
            string line;
            var file = new StreamReader(filename);
            while ((line = file.ReadLine()) != null)
            {
                if ((line.Split(new Char[] {' '})).Length != 2)
                {
                    Console.WriteLine("Incorrect 1st file input, aborting.");
                    return;
                }

                Point newPoint = Point.Parse(line);

                //Console.WriteLine(newPoint.X + ", " + newPoint.Y);

                pointList.Add(newPoint);
            }
            file.Close();
        }

        static void PrintCoordList(List<Point> coordList)
        {
            foreach (Point point in coordList)
            {
                Console.WriteLine(point.X + " " + point.Y);
            }
        }

        public static double GetDistanceBetweenPoints(Point p, Point q)
        {
            double a = p.X - q.X;
            double b = p.Y - q.Y;
            double distance = Math.Sqrt(a * a + b * b);
            return distance;
        }

        public static void GetAllSegments(List<Tuple<Point, Point>> segments, int PointListIndex)
        {
            for (int i = 0; i < pointLists[PointListIndex].Count; i++)
            {
                for (int j = i + 1; j < pointLists[PointListIndex].Count; j++)
                {
                    segments.Add(new Tuple<Point, Point>(pointLists[PointListIndex][i], pointLists[PointListIndex][j]));
                }
            }
        }

        static List<Tuple<Point, Point, Point, Point>> FindSimilarSegments()
        {
            List<Tuple<Point, Point>>[] segments = { new List<Tuple<Point, Point>>(), new List<Tuple<Point, Point>>() };

            GetAllSegments(segments[0], 0);
            GetAllSegments(segments[1], 1);

            foreach (Tuple<Point, Point> segment0 in segments[0])
            {
                foreach (Tuple<Point, Point> segment1 in segments[1])
                {
                    if (GetDistanceBetweenPoints(segment0.Item1, segment0.Item2) -
                        GetDistanceBetweenPoints(segment1.Item1, segment1.Item2) < delta)
                    {
                        similarSegments.Add(new Tuple<Point, Point, Point, Point>(segment0.Item1, segment0.Item2, segment1.Item1, segment1.Item2));
                    }
                }
            }

            return similarSegments;
        }

        private static void GeneratePointList1Split()
        {
            var pointList1 = pointLists[1].OrderBy(p => p.X).ToList();

            int j = 0;
            for (int i = 0; ; i += divWidth)
            {
                pointList1Split.Add(new List<Point>());
                for (; j < pointList1.Count; j++)
                {
                    if (pointList1[j].X >= i && pointList1[j].X < i + divWidth)
                    {
                        pointList1Split[i / divWidth].Add(pointList1[j]);
                    }
                    if (pointList1[j].X >= i + divWidth)
                    {
                        break;
                    }
                }
                if (j == pointLists[1].Count)
                {
                    break;
                }
            }
        }

        static void Main(string[] args)
        {
            int correspondPointCount = 0;
            ReadCoordList("C:\\input0.txt", pointLists[0]);
            ReadCoordList("C:\\input1.txt", pointLists[1]);

            PrintCoordList(pointLists[0]);

            GeneratePointList1Split();

            FindSimilarSegments();

            foreach (Tuple<Point, Point, Point, Point> segmentPair in similarSegments) 
            {
                Vector[] vectors0 = 
                {
                    new Vector(segmentPair.Item2.X - segmentPair.Item1.X, segmentPair.Item2.Y - segmentPair.Item1.Y),
                    new Vector(segmentPair.Item1.X - segmentPair.Item2.X, segmentPair.Item1.Y - segmentPair.Item2.Y)
                };
                Vector vector1 = new Vector(segmentPair.Item4.X - segmentPair.Item3.X, segmentPair.Item4.Y - segmentPair.Item3.Y);

                foreach (Vector vector0 in vectors0) 
                {
                    double angle = (Math.PI / 180) * Vector.AngleBetween(vector0, vector1);
                    double newPoint1X = segmentPair.Item1.X * Math.Cos(angle) - segmentPair.Item1.Y * Math.Sin(angle);
                    double newPoint1Y = segmentPair.Item1.X * Math.Sin(angle) + segmentPair.Item1.Y * Math.Cos(angle);

                    Tuple<double, double> translation;
                    if (angle < Math.PI / 2) // For straight vs. reverse matching
                    {
                        translation = new Tuple<double, double>(segmentPair.Item3.X - newPoint1X, segmentPair.Item3.Y - newPoint1Y);
                    }
                    else
                    {
                        translation = new Tuple<double, double>(segmentPair.Item4.X - newPoint1X, segmentPair.Item4.Y - newPoint1Y);
                    }

                    var transPointList0 = (List<Point>)DeepClone(pointLists[0]);
                    for (int i = 0; i < transPointList0.Count; i++)
                    {
                        var point = transPointList0[i];
                        point.X = point.X * Math.Cos(angle) - point.Y * Math.Sin(angle) + translation.Item1;
                        point.Y = point.X * Math.Sin(angle) + point.Y * Math.Cos(angle) + translation.Item2;
                        transPointList0[i] = point;
                    }

                    int curCorrespondPointCount = 0;
                    var tempPointList1Split = (List<List<Point>>)DeepClone(pointList1Split);
                    foreach (Point point0 in transPointList0)
                    {
                        int index = (int)(point0.X / divWidth);
                        foreach (Point point1 in tempPointList1Split[index])
                        {
                            if (GetDistanceBetweenPoints(point0, point1) < delta)
                            {
                                tempPointList1Split[index].Remove(point1);
                                curCorrespondPointCount++;
                                break;
                            }
                        }
                    }
                    if (curCorrespondPointCount > correspondPointCount)
                    {
                        correspondPointCount = curCorrespondPointCount;
                    }
                }
            }

            Console.WriteLine("Corresponding points count: " + correspondPointCount);
        }
    }
}