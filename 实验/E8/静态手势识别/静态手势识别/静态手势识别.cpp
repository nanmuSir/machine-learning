// 静态手势识别.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include "pch.h"
#include <string>
#include <stdio.h>
#include <iostream>
#include <cstring>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>      
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <sstream>
#include <iostream>
#include <io.h>
#include <fstream> 
#include <iterator>
#include <vector>
#include <Windows.h>
#include <math.h>

using namespace cv;
using namespace std;

//void getFiles(string path, vector<string>& files);
int main()
{
	Mat YCrCb_detect(Mat & input_image);
	void largestArea(Mat &src);
	void getFiles(string path, vector<string>& files);
	//Mat ellipse_detect(Mat& src);
	//int getX(Mat &src);
	//int getY(Mat &src);
	int XLoutline(Mat &src);
	int XRoutline(Mat &src);
	int Youtline(Mat &src);
	//int getArea(Mat &src);
	int saomiao(int row, int col, double R, Mat &src, Mat &temp);

	vector<string> files;
	string filePath = "E:\\C++\\静态手势识别\\finger\\my";
	////获取该路径下的所有文件  
	getFiles(filePath, files);

	char str[30];
	int size = files.size();
	int i = 0;
	//while (i < files.size())
	//{	
	string path = "E:\\C++\\静态手势识别\\finger\\pp.jpg";//+ files[i];
	int resize_height = 256;
	int resize_width = 256;
	//Mat src = imread(files[i]); //从路径名中读取图片
	//i++;
	Mat src = imread(path);
	Mat Dst;
	resize(src, Dst, Size(resize_width, resize_height), (0, 0), (0, 0), INTER_LINEAR);//重新调整图像大小		
	Mat p2 = YCrCb_detect(Dst);
	Mat gray_image;
	cvtColor(p2, gray_image, CV_BGR2GRAY);
	Mat temp;
	medianBlur(gray_image, temp, 3);   //孔径为3，将邻域点的灰度值中值作为该点的值
	Mat result;
	result = temp.clone();
	threshold(temp, result, 30, 200.0, CV_THRESH_BINARY);  //二值化   30为阈值大于30则为200
	imshow("二值化", result);
	largestArea(result);
	imshow("最大连通区域", result);
	int xLline = XLoutline(result);  //左边界
	int xRline = XRoutline(result);  //右边界
	int yline = Youtline(result);       //上边界
	int col = xLline + (xRline - xLline) / 2;      //圆心的col
	double r = (xRline - xLline) / 2 * 1.21;        //圆心的row
	//cout << r <<" "<<xRline<<" "<<xLline<<" "<< endl;
	Mat huatu = result.clone();
	int row = int(yline + r) + 5;
	int line = int(yline + r);
	int number = saomiao(row, col, r, result, huatu);
	//cout << r << endl;
	cout << xRline << " " << xLline << endl;
	//cout << row << " " << col << endl;
	int quan[] = { 0,0,0,0,0,0 };
	quan[number]++;
	while (int(row - r) < line - int(r / 5))//result.rows)
	{
		row = row + 5;
		number = saomiao(row, col, r, result, huatu);
		quan[number]++;
	}
	int max = 0;
	for (int i = 1; i < 6; i++)
	{
		cout << quan[i] << " ";
		if (quan[i] > 3)
			max = i;
	}
	cout << "权" << endl;
	stringstream count;
	count << max;
	//count <<"第"<<i-1<<"张个数为"<< max;
	imshow(count.str(), p2);
	imshow("画图", huatu);
	//}
	waitKey(0);
	return 0;
}

int saomiao(int row, int col, double R, Mat &src, Mat &temp)
{
	//temp.at<uchar>(row,col) =0;
	double rad = 200.0;
	double hudu = 0.0;
	int  result = 0, num = 0, xlength, ylength;
	/*while (rad < 315.0)
	{
		hudu = rad * 3.14 / 180;
		xlength = int(R * cos(hudu));
		ylength = int(R * sin(hudu));
		if (row + ylength<0 || row + ylength>src.rows-1 || col + xlength<0 || col + xlength>src.cols-1)
			rad=rad+0.5;
		else if (src.at<uchar>(row + ylength, col + xlength) == 200)
		{
			rad = rad +0.5;
		}
		else
			break;
	}*/
	while (rad < 330.0)
	{
		hudu = rad * 3.14 / 180;
		xlength = int(R * cos(hudu));
		ylength = int(R * sin(hudu));
		if (row + ylength<0 || row + ylength>src.rows - 1 || col + xlength<0 || col + xlength>src.cols - 1) //防止外溢
		{
			rad = rad + 0.5;
		}
		else if (src.at<uchar>(row + ylength, col + xlength) == 0)
		{
			num = 0;
			rad = rad + 0.5;
		}
		else
		{
			//cout << xlength << " " << ylength <<" "<< X+xlength<<" "<<Y+ylength<< " "<<rad<<" "<<R << endl;
			temp.at<uchar>(row + ylength, col + xlength) = 0;
			num++;
			if (num == 10)
			{
				result++;
			}
			if (num == int(R / 2))
			{
				result = 0;
				return result;
				break;
			}
			rad = rad + 0.5;
		}
	}

	return result;
}

int XLoutline(Mat &src)//左侧
{
	for (int i = 0; i < src.cols; i++)
	{
		//cout << endl;
		for (int j = 0; j < src.rows; j++)
		{
			int m = src.at<uchar>(j, i);
			//cout << m << " ";
			if (m == 200)
			{
				return i;
			}
		}
	}
}
int XRoutline(Mat &src)//右侧
{
	int index = 0;
	//for (int i = src.cols-1; i >=0; i--)
	for (int i = 0; i < src.cols; i++)
	{
		for (int j = 0; j < src.rows; j++)
		{
			int m = src.at<uchar>(j, i);
			if (m == 200)
				index = i;
		}
	}
	return index;
	//return 200;
}

int Youtline(Mat &src)//上侧
{
	for (int i = 0; i < src.rows; i++)
	{
		for (int j = 0; j < src.cols; j++)
		{
			int m = src.at<uchar>(i, j);
			if (m == 200)
				return i;
		}
	}
}

/*int getX(Mat &src)//得到重心的横坐标
{
	int sum = 0;
	int sumPot = 0;
	for (int i = 0; i < src.rows; i++)
	{
		for (int j = 0; j < src.cols; j++)
		{
			int m = src.at<uchar>(i, j);
			sumPot += m;
			sum += j * m;
		}
	}
	return sum / sumPot;
}
int getY(Mat &src)//得到重心的纵坐标
{
	int sum = 0;
	int sumPot = 0;
	for (int i = 0; i < src.rows; i++)
	{
		for (int j = 0; j < src.cols; j++)
		{
			int m = src.at<uchar>(i, j);
			//cout << m << " ";
			sumPot += m;
			sum += i * m;
		}
		//cout << endl;
	}
	return sum / sumPot;
}



int getArea(Mat &src)//得到重心的纵坐标
{
	int sum = 0;
	for (int i = 0; i < src.rows; i++)
	{
		for (int j = 0; j < src.cols; j++)
		{
			int m = src.at<uchar>(i, j);
			if (m == 200)
				sum++;
		}
	}
	return sum;
}*/

void getFiles(string path, vector<string>& files)
{
	//文件句柄  
	intptr_t   hFile = 0;
	//文件信息  
	struct _finddata_t fileinfo;
	string p;
	if ((hFile = _findfirst(p.assign(path).append("\\*").c_str(), &fileinfo)) != -1)
	{
		do
		{
			//如果是目录,迭代之  
			//如果不是,加入列表  
			if ((fileinfo.attrib &  _A_SUBDIR))
			{
				if (strcmp(fileinfo.name, ".") != 0 && strcmp(fileinfo.name, "..") != 0)
					getFiles(p.assign(path).append("\\").append(fileinfo.name), files);
			}
			else
			{
				files.push_back(p.assign(path).append("\\").append(fileinfo.name));
			}
		} while (intptr_t(_findnext(hFile, &fileinfo)) == 0);
		_findclose(hFile);
	}
}

Mat YCrCb_detect(Mat & src)
{
	Mat ycrcb_image;
	int Cr = 1;
	int Cb = 2;
	cvtColor(src, ycrcb_image, CV_BGR2YCrCb); //首先转换成到YCrCb空间
	Mat output_mask = Mat::zeros(src.size(), CV_8UC1);
	for (int i = 0; i < src.rows; i++)
	{
		for (int j = 0; j < src.cols; j++)
		{
			//Cr反映了RGB输入信号红色部分与RGB信号亮度值之间的差异。而Cb反映的是RGB输入信号蓝色部分与RGB信号亮度值之同的差异。
			uchar *p_mask = output_mask.ptr<uchar>(i, j);//单通道灰度值图片cv_8uc1
			uchar *p_src = ycrcb_image.ptr<uchar>(i, j);//cr与cb分别代表色调和饱和度,y为亮度
			if (p_src[Cr] >= 130 && p_src[Cr] <= 160 && p_src[Cb] >= 77 && p_src[Cb] <= 127)
			{//133    173    77    127
				p_mask[0] = 255;  //0通道为255
			}
		}
	}
	Mat detect;
	src.copyTo(detect, output_mask); //将mask敷衍到src上，给src打马赛克，黑色掩盖src
	return detect;
}

void largestArea(Mat &src)
{
	vector<vector<cv::Point>> contours;
	cv::findContours(src, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);

	// 寻找最大连通域
	double maxArea = 0;
	vector<cv::Point> maxContour;
	for (size_t i = 0; i < contours.size(); i++)
	{
		double area = cv::contourArea(contours[i]);
		if (area > maxArea)
		{
			maxArea = area;
			maxContour = contours[i];
		}
	}

	// 将轮廓转为矩形框
	cv::Rect maxRect = cv::boundingRect(maxContour);

	// 显示连通域
	int x = maxRect.x;
	int y = maxRect.y;
	int w = maxRect.width;
	int h = maxRect.height;
	cout << x << " " << y << " " << w << " " << h << endl;
	for (int i = 0; i < src.rows; i++)
	{
		for (int j = 0; j < src.cols; j++)
		{
			if (i<y || i>y + h || j<x || j>x + w)
				src.at<uchar>(i, j) = 0;
		}
	}

	/*Rect rect(x, y, w, h);
	Mat ROI = src(rect);
	Mat Dst;
	resize(ROI, Dst, Size(200, 200), (0, 0), (0, 0), INTER_LINEAR);//重新调整图像大小
	IplImage* img = IplImage(Dst);
	CvRect roi0 = cvRect(0, 0, 200, 200);
	Mat output = Mat::zeros(src.size(), CV_8UC1);
	IplImage* img1 = IplImage(output);
	CvRect roi1 = cvRect(28, 28, 200, 200);

	cvSetImageROI(img, roi);
	cvSetImageROI(img1, roi1);
	cvCopy(img1, img);
	cvResetImageROI(img);
	cvResetImageROI(img1);

	cvSetImageROI(output, roi1);

	src.copyTo(output);
	return output;
	Mat img = cv::cvarrToMat(iplimg);*/
}