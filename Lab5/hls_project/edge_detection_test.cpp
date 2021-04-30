#include "edge_detection.h"
#include "common/xf_headers.hpp"
#include "common/xf_utility.hpp"
//Testbench that uses OpenCV to open a test image, wrap it in an AXI-Stream,
//pipe it into the function under test and save the result into the output image.
int main(int argc, char** argv)
{

	cv::Mat src = cv::imread(INPUT_IMAGE);
	cv::Mat dst = src;

	// Generate Sobel from OpenCV for comparison
	cv::Mat src_gray, grad_x, grad_y;
	cv::cvtColor(src, src_gray, 6);//bgr to gray
    cv::Sobel(src_gray, grad_x, CV_16S, 1, 0);
    cv::Sobel(src_gray, grad_y, CV_16S, 0, 1);
	cv::imwrite(OUTPUT_CV_IMAGE_X, grad_x);
	cv::imwrite(OUTPUT_CV_IMAGE_Y, grad_y);

	// Generate Sobel from Vitis Vision
	xf::cv::Mat <XF_8UC3, MAX_HEIGHT, MAX_WIDTH, XF_NPPC1> xf_src(MAX_HEIGHT, MAX_WIDTH);
	xf::cv::Mat <XF_8UC3, MAX_HEIGHT, MAX_WIDTH, XF_NPPC1> xf_dst_x(MAX_HEIGHT, MAX_WIDTH);
	xf::cv::Mat <XF_8UC3, MAX_HEIGHT, MAX_WIDTH, XF_NPPC1> xf_dst_y(MAX_HEIGHT, MAX_WIDTH);

	xf_src.copyTo(src.data);

	stream_t stream_in, stream_out1, stream_out2;
	xf::cv::xfMat2AXIvideo<24, XF_8UC3, MAX_HEIGHT, MAX_WIDTH, XF_NPPC1>(xf_src, stream_in);
	edge_detect(stream_in, stream_out1, stream_out2);
	xf::cv::AXIvideo2xfMat<24, XF_8UC3, MAX_HEIGHT, MAX_WIDTH, XF_NPPC1>(stream_out1, xf_dst_x);
	xf::cv::AXIvideo2xfMat<24, XF_8UC3, MAX_HEIGHT, MAX_WIDTH, XF_NPPC1>(stream_out2, xf_dst_y);

	dst.data = xf_dst_x.copyFrom();
	cv::imwrite(OUTPUT_IMAGE_X, dst);

	dst.data = xf_dst_y.copyFrom();
	cv::imwrite(OUTPUT_IMAGE_Y, dst);

	return 0;
}
