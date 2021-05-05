#include "edge_detection.h"
void edge_detect(stream_t& stream_in, stream_t& stream_out_x, stream_t& stream_out_y)
{
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis register_mode=both register port=stream_out_x
#pragma HLS INTERFACE axis register_mode=both register port=stream_out_y
#pragma HLS INTERFACE axis register_mode=both register port=stream_in
	//xf::cv::Mat-type local variables for intermediate results
	rgb_img_t  src(MAX_HEIGHT, MAX_WIDTH);
	gray_img_t src_gray(MAX_HEIGHT, MAX_WIDTH);
	gray_img_t grad_x(MAX_HEIGHT, MAX_WIDTH);
	gray_img_t grad_y(MAX_HEIGHT, MAX_WIDTH);
	rgb_img_t  rgb_x(MAX_HEIGHT, MAX_WIDTH);
	rgb_img_t  rgb_y(MAX_HEIGHT, MAX_WIDTH);

  //Interpret AXI-Stream interface and pull the frame from it
	xf::cv::AXIvideo2xfMat(stream_in, src);
  //Convert to grayscale
	xf::cv::rgb2gray(src, src_gray);
  //Run the Sobel operator on the x-axis with a 3x3 kernel
	xf::cv::Sobel<XF_BORDER_CONSTANT,XF_FILTER_3X3>(src_gray, grad_x, grad_y);
  //Convert back to RGB format for display purposes
	xf::cv::gray2rgb(grad_x, rgb_x);
	xf::cv::gray2rgb(grad_y, rgb_y);

  //Pack the frame back into AXI-Stream interface
	xf::cv::xfMat2AXIvideo(rgb_x, stream_out_x);
	xf::cv::xfMat2AXIvideo(rgb_y, stream_out_y);
}
