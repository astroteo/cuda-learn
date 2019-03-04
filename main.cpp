#include <iostream>
#include <math.h>

// CUDA Kernel function to add the elements of two arrays on the GPU

bool CUDA_ = false;


__global__ void mykernel(void) {
}

float*
add(int N, float* x, float* y)
{
	float* z = new float[N];

	for (int i =0; i< N; ++i)
	{
		z[i] = (float) x[i] + (float) y[i];
	}
	return z;
}


int main(void)
{
	int N = 10;

	float* x = new float[N];
	float* y = new float[N];


	for(int j=0; j< N; ++j)
	{
		x[j] = j;
		y[j] = j;
	}

	float* z;
	z = add(N,x,y);




	for (int i=0; i< N ; ++i)
	{
		std::cout << "x ==> " <<std::endl;
		std::cout << x[i]<<std::endl;
		std::cout << "y ==> " <<std::endl;
		std::cout << y[i]<<std::endl;
		std::cout << "z ==> " <<std::endl;
		std::cout << z[i]<<std::endl;
	}

	// Free memory
  	delete [] x;
  	delete [] y;



	return 0;
}
