#include "stdafx.h"
#include "Neural_Network.h"

using namespace std;
using namespace cv;

Neural_Network::Neural_Network(int l[]) {
	layers = l;

	//@TODO do this as loop
	first_weighted_matrix = Mat(layers[1], layers[0], CV_8U);
	second_weighted_matrix = Mat(layers[2], layers[1], CV_8U);

	initialize_weights();
}

Neural_Network::~Neural_Network() {

}

void Neural_Network::initialize_weights() {
	// First Matrix
	for (int i = 0; i < num_nodes_second_layer; i++) {
		for (int j = 0; j < num_input_layer; j++) {
			first_weighted_matrix.at<double>(i, j) = ((double)rand() / RAND_MAX);
		}
	}

	// Second Matrix
	for (int i = 0; i < num_output_layer; i++) {
		for (int j = 0; j < num_nodes_second_layer; j++) {
			second_weighted_matrix.at<double>(i, j) = ((double)rand() / RAND_MAX);
		}
	}
}