#include <iostream>
#include <math.h>
#include <cstdio>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
/*
to be compiled via nvcc ==> nvcc main.cu -o exec

*/
// CUDA Kernel function to add the elements of two arrays on the GPU

bool CUDA_ = false;

// __device__ indicates funtion to be executed by the gpu
__global__ 
void mykernel(void) {

	printf( "hello from CUDA \n ==> saying hello from GPU \n"); // dunno why ==> works only with printf

}

__global__
void
summer_kernel(int* a )
{
	*a = *a +1;
}

__global__ 
void add_tut
(int *a, int *b, int *c) 
{
*c = *a + *b;
}
// __global__ functions must be void, are meant ot be called by device(GPU)
__global__
void
add(int N, int *x, int *y, int *add_result)
{	
	
	for (int i =0; i< N; ++i)
	{
		add_result[i] =  x[i] +  y[i];
	}
	 int i = blockIdx.x * blockDim.x + threadIdx.x;
	 if (i < N) {
	 add_result[i] = x[i] + y[i];
	}
}
/*
__global__
add_smart
{
c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}
*/


int main(void)
{
    int print_N_time_in_parallel = 12;
	mykernel<<<print_N_time_in_parallel,1>>>(); // function invoked on GPU
	

	// executing same operation on device:
	int execute_N_time_in_parallel = 12;

	int a_host;
	a_host = 0;

	int *a_device;
	//(1) alloc memory on GPU
	cudaMalloc((void **)&a_device, sizeof(int));
	//(2) copy value(s) into GPU variable
	cudaMemcpy(a_device, &a_host,sizeof(int),cudaMemcpyHostToDevice);
	//(3) execute command
	summer_kernel <<< execute_N_time_in_parallel,1 >>>(a_device);
	// (4) copy back into original value
	int a_result;
	cudaMemcpy(&a_result,a_device, sizeof(int), cudaMemcpyDeviceToHost);// returns 1 but execute it 12 times in parallel



	
	std::cout << "EOC, sigle value ==> a_host = "<< a_result <<std::endl;
	/*
	summing 2 vector on device
	*/
	const int N = 10;

	// host arrays
    int x[N] = {  1,  2,  3,  4,  5 };
    int y[N] = { 10, 20, 30, 40, 50 };
    int z[N] = {0};

	// device copies
	int size_f = sizeof(int);

	int *d_x = 0;
	int *d_y = 0;
	int *d_z = 0;



	// vectors alllocation on GPU
	cudaMalloc((void **)&d_x, size_f*N);
	cudaMalloc((void **)&d_y, size_f*N);
	cudaMalloc((void **)&d_z, size_f*N);

	// copy values, this operation maps device-values and host-values
	cudaMemcpy(d_x, x, size_f*N, cudaMemcpyHostToDevice);
	cudaMemcpy(d_y, y, size_f*N, cudaMemcpyHostToDevice);

	//Launch add() kernel on GPU
	/*
	 Launch a kernel on the GPU with one thread for each element.
     2 is number of computational blocks and (N + 1) / 2 is a number of threads in a block
 	*/
	add<<<2, (N + 1) / 2>>>(N, d_x, d_y, d_z);

	/* cudaDeviceSynchronize waits for the kernel to finish, and returns
   		any errors encountered during the launch.*/
	cudaDeviceSynchronize();

	cudaMemcpy(z, d_z, size_f*N, cudaMemcpyDeviceToHost);

	
	 printf("{1, 2, 3, 4, 5} + {10, 20, 30, 40, 50} = {%d, %d, %d, %d, %d}\n", z[0], z[1], z[2], z[3], z[4]);

	int a, b, c;
	int *d_a, *d_b, *d_c;
	int size = sizeof(int);

	cudaMalloc((void **)&d_a, size);
	cudaMalloc((void **)&d_b, size);
	cudaMalloc((void **)&d_c, size);

	a = 22;
	b = 44;

	cudaMemcpy(d_a, &a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, &b, size, cudaMemcpyHostToDevice);
	add_tut<<<execute_N_time_in_parallel,1>>>(d_a, d_b, d_c);
	cudaMemcpy(&c, d_c, size, cudaMemcpyDeviceToHost);

	std::cout << "tutorial==> sum result is \n c = "<< c << std::endl;
	/* following line fails ahhahhahha 
	===>std::cout << "tutorial==> sum result is \n *d_c = "<< *d_c << std::endl; <=== */




	// Free memory
  	//delete [] d_x;
  	//delete [] d_y;
  	cudaDeviceReset();
  	cudaFree(d_x);
  	cudaFree(d_y);
  	cudaFree(d_a);
  	cudaFree(d_b);
	







	return 0;
}