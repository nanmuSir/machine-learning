// 手势识别.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include "pch.h"
/*
 * 摄像头读取-->
 * HSV颜色空间转换及通道分离-->
 * 肤色分割-->
 * 中值滤波-->
 * 轮廓检测及过滤-->
 * 轮廓形状匹配
 *
 */


#include <iostream>
#include <string>

#include <opencv2\opencv.hpp>
using namespace cv;
using namespace std;

#define MAXVALUE (80)
#define KERNEL_SIZE (7)

int minVal = 7, maxVal = 20;

int is_using_canny = 0;
int canny_threshold = 3;

Mat frame;                  //原始图像帧
vector <Mat> channels;      //HSV通道分离
Mat frameH;                 //H通道
Mat result;                 //最终结果
Mat resultRGB;              //将结果显示在原图

int match_number = -1;

//模板总数
#define TEMPLATE_NUMS   (10)
vector< vector<Point> > mContoursTemp;  //轮廓模板集
vector< vector<Point> > mContoursProc;  //待处理轮廓集


//分割H通道时的最小值
void trackBarMin(int pos, void* userdata)
{}
//分割H通道时的最大值
void trackBarMax(int pos, void* userdata)
{}

//是否使用Canny边缘检测
void isUsingCanny(int pos, void* userdata)
{}

//分割H通道时的最大值
void cannyThreshold(int pos, void* userdata)
{}


//载入模板的轮廓
void init_hand_template(void);

// 对肤色分割、滤波去噪、开运算后图像进行轮廓提取并过滤
void hand_contours(Mat &srcImage);

// 将目标轮廓与模板轮廓进行匹配
void hand_template_match(void);

// 在图片的左上角标注数字
void number_draw(Mat &img, int num);

// 将Mat中的每个元素设置为某个数值
void setMatInt(Mat & input_image, uchar val);

int main()
{
	// 载入模板的轮廓
	init_hand_template();

#if 1
	namedWindow("original");
	namedWindow("TrackBar");
	namedWindow("result");

	createTrackbar("minVal", "TrackBar", &minVal, MAXVALUE, trackBarMin);
	createTrackbar("maxVal", "TrackBar", &maxVal, MAXVALUE, trackBarMax);

	createTrackbar("is_using_canny", "TrackBar", &is_using_canny, 1, isUsingCanny);
	createTrackbar("canny_threshold", "TrackBar", &canny_threshold, 120, cannyThreshold);

	// 打开摄像头
	VideoCapture capture(0);
	if (false == capture.isOpened())
	{
		cout << "camera open failed!" << endl;
		return -1;
	}

	Mat kernel = getStructuringElement(MORPH_RECT, Size(KERNEL_SIZE, KERNEL_SIZE));

	while (true)
	{
		// 获取图片帧
		capture >> frame;
		if (true == frame.empty())
		{
			cout << "get no frame" << endl;
			break;
		}

		// 显示原始图片
		imshow("original", frame);
		resultRGB = frame.clone();

		// 转换HSV颜色通道
		cvtColor(frame, frame, CV_BGR2HSV);

		// HSV通道分离
		split(frame, channels);
		frameH = channels[0];

		// 显示H通道图片
//        imshow("H-channels", frameH);

		// 肤色分离-使用OpenCV自带函数
		inRange(frameH, Scalar(minVal), Scalar(maxVal), result);

		//------------------------------滤波平滑-----------------------------
		// 中值滤波: 可以很好的去除椒盐噪声，而且ksize越大效果越好。
		medianBlur(result, result, 11);

		//----------------------------形态学运算-----------------------------
		/*
		 * 腐蚀 MORPH_ERODE
		 * 膨胀 MORPH_DILATE
		 * 开运算 MORPH_OPEN
		 * 闭运算 MORPH_CLOSE
		 * 形态学梯度 MORPH_GRADIENT
		 * 顶帽 MORPH_TOPHAT
		 * 黑帽 MORPH_BLACKHAT
		 */
		morphologyEx(result, result, MORPH_OPEN, kernel);

		// 显示结果图片
		imshow("Before Contour Detect", result);

		// 对肤色分割、滤波去噪、开运算后图像进行轮廓提取并过滤
		hand_contours(result);

		// 将目标轮廓与模板轮廓进行匹配
		hand_template_match();

		// 显示结果图片
//        imshow("result", result);

		// 将匹配结果显示到图片的左上角
		number_draw(resultRGB, match_number);
		imshow("resultRGB", resultRGB);


		char key = (char)waitKey(10);
		if (27 == key)
		{
			break;
		}
	}
#endif

	return 0;
}
char *tmp_names[TEMPLATE_NUMS] = { (char*)"E:/C++/手势识别/1.bmp",(char*)"E:/C++/手势识别/2.bmp",(char*)"E:/C++/手势识别/3.bmp",
(char*)"E:/C++/手势识别/4.bmp",(char*)"E:/C++/手势识别/5.bmp",(char*)"E:/C++/手势识别/6.bmp",(char*)"E:/C++/手势识别/7.bmp",
(char*)"E:/C++/手势识别/8.bmp",(char*)"E:/C++/手势识别/9.bmp",(char*)"E:/C++/手势识别/10.bmp" };

//载入模板的轮廓
void init_hand_template(void)
{
	Mat srcImage;
	Mat dstImage;
	vector< vector<Point> > mContours;
	vector< Vec4i > mHierarchy;

	for (int i = 0; i < TEMPLATE_NUMS; i++)
	{
		// 读取文件
		srcImage = imread(tmp_names[i], IMREAD_GRAYSCALE);
		if (true == srcImage.empty())
		{
			cout << "Failed to load image: " << tmp_names << endl;
			continue;
		}

		dstImage = Mat::zeros(srcImage.rows, srcImage.cols, CV_8UC3);

		// 寻找轮廓
		findContours(srcImage, mContours, mHierarchy, RETR_CCOMP, CHAIN_APPROX_NONE, Point(0, 0));

		//        cout << "contours size = " << mContours.size() << endl;
		if (mContours.size() > 0)
		{
			//            drawContours(dstImage, mContours, 0, Scalar(0, 0, 255), 1, 8, mHierarchy);
			//            imshow(tmp_names[i], dstImage);
			mContoursTemp.insert(mContoursTemp.end(), mContours.begin(), mContours.end());
		}
	}

	cout << "mContoursTemp size = " << mContoursTemp.size() << endl;

}

// 对肤色分割、滤波去噪、开运算后图像进行轮廓提取并过滤
void hand_contours(Mat &srcImage)
{
	Mat imageProc = srcImage.clone();

	Size sz = srcImage.size();
	Mat draw = Mat::zeros(sz, CV_8UC3);

	vector< vector<Point> > mContours;
	vector< Vec4i > mHierarchy;


#if 1
	// 经过实验验证此处增加Canny边缘检测，对实验结果没有改善
	if (1 == is_using_canny)
	{
		cout << "canny_threshold = " << canny_threshold << endl;
		Canny(imageProc, imageProc, canny_threshold, canny_threshold * 2, 3);
	}

#endif

	//只查找最外层轮廓
	findContours(imageProc, mContours, mHierarchy, RETR_EXTERNAL, CHAIN_APPROX_NONE, Point(0, 0));

	mContoursProc.clear();  //清空上次图像处理的轮廓

	if (mContours.size() > 0)
	{
		// 绘制所有轮廓
		drawContours(draw, mContours, -1, Scalar(0, 0, 255), 1, 8, mHierarchy);
		imshow("All Contours", draw);


		double contArea = 0;
		double imageArea = sz.width * sz.height;
		const int SIZE = mContours.size();

		Rect bound;

		for (int i = 0; i < SIZE; i++)
		{
			contArea = contourArea(mContours[i]);

			// 过滤小面积的轮廓
			if (contArea / imageArea < 0.015)
			{
				continue;
			}

			// 如果轮廓边界与窗口贴近或者相连，则排除
			bound = boundingRect(mContours[i]);
			if (bound.x < 2
				|| bound.y < 2
				|| (bound.x + bound.width + 2) > sz.width
				|| (bound.y + bound.height + 2) > sz.height)
			{
				continue;
			}

			//剩下的轮廓就是基本符合条件的轮廓，保存起来
			mContoursProc.push_back(mContours[i]);
		}
		//        cout << "mContoursProc.size = " << mContoursProc.size() << endl;
				// 绘制过滤后的轮廓
		//        setMatInt(draw, 0);           //将矩阵所有元素赋值为某个值
		draw = Scalar::all(0);          //将矩阵所有元素赋值为某个值
		drawContours(draw, mContoursProc, -1, Scalar(0, 0, 255), 1, 8);
		imshow("Filter Contours", draw);
	}
}

// 将目标轮廓与模板轮廓进行匹配
void hand_template_match(void)
{
	if ((mContoursProc.size() == 0) || (mContoursTemp.size() == 0))
	{
		//        cout << "There are no contours to match" << endl;
		return;
	}

	double hu = 1.0, huTmp = 0.0;
	const int SIZE = mContoursProc.size();
	int m = -1, n = -1;
	match_number = -1;

	for (int i = 0; i < TEMPLATE_NUMS; i++)
	{
		for (int j = 0; j < SIZE; j++)
		{
			huTmp = matchShapes(mContoursTemp[i], mContoursProc[j], CV_CONTOURS_MATCH_I1, 0);

			// hu矩越小，匹配度越高
			if (huTmp < hu)
			{
				hu = huTmp;

				//保存好，是哪个轮廓和哪个模板匹配上了
				m = i;
				n = j;
			}
		}
	}

	cout << "************m = " << (m + 1) << "; n = " << n << "; hu = " << hu << endl;

	// 匹配到的数字
	match_number = m + 1;

}

const char *num_char[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" };
// 在图片的左上角标注数字
void number_draw(Mat &img, int num)
{
	//未识别到任何数字
	if (num < 1)
	{
		return;
	}

	string text = num_char[num - 1];
	putText(img, text, Point(5, 100), FONT_HERSHEY_SIMPLEX, 4, Scalar(0, 0, 255), 5);

	//    int baseline = 0;
	//    Size textSize = getTextSize(text, FONT_HERSHEY_SIMPLEX, 2, 2, &baseline);
	//    cout << "textsize.w = " << textSize.width << " textsize.h = " << textSize.height << endl;
}


//将Mat中的每个元素设置为某个数值
void setMatInt(Mat & input_image, uchar val)
{
	//行数
	int rows = input_image.rows;

	//列数x通道数=每一行的元素个数
	int cols = input_image.cols * input_image.channels();

	for (int i = 0; i < rows; i++)
	{
		uchar *pdata = input_image.ptr<uchar>(i);
		for (int j = 0; j < cols; j++)
		{
			pdata[j] = val;
		}
	}

}