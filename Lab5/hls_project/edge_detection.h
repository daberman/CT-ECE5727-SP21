#define _GLIBCXX_USE_CXX11_ABI 0
#include "common/xf_common.hpp"
#include "common/xf_infra.hpp"
#include "imgproc/xf_cvt_color.hpp"
#include "imgproc/xf_sobel.hpp"
#include "imgproc/xf_convertscaleabs.hpp"

typedef ap_axiu<24,1,1,1> interface_t;
typedef hls::stream<interface_t> stream_t;

#define INPUT_IMAGE "fox.bmp"
#define OUTPUT_IMAGE_X "fox_sobel_x.bmp"
#define OUTPUT_IMAGE_Y "fox_sobel_y.bmp"
#define OUTPUT_CV_IMAGE_X "fox_cvsobel_x.bmp"
#define OUTPUT_CV_IMAGE_Y "fox_cvsobel_y.bmp"

#define MAX_HEIGHT 720
#define MAX_WIDTH 1280

typedef xf::cv::Mat<XF_8UC3, MAX_HEIGHT, MAX_WIDTH, XF_NPPC1> rgb_img_t;
typedef xf::cv::Mat<XF_8UC1, MAX_HEIGHT, MAX_WIDTH, XF_NPPC1> gray_img_t;

//Synthesizable function declaration
void edge_detect(stream_t& stream_in, stream_t& stream_out1, stream_t& stream_out2);
