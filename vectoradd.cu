/* 
   * This example explains how to divide the host and 
   * device code into separate files using vector addition 
*/
#include "kernel.h"
#define N 64



__global__ void addKernel(float *a,float *b) {
	int idx=threadIdx.x+blockIdx.x*blockDim.x;

	if(idx>=N) return;
		a[idx]+=b[idx];
}


void vectorAdd() {
	//host memory
	float *h_arr1,*h_arr2,*h_res;
	size_t size=N*sizeof(float);

	//allocate host memory
	h_arr1=(float*)malloc(size);
	h_arr2=(float*)malloc(size);
	h_res=(float*)malloc(size);

	//populate the host arrays
	for(int i=0;i<N;i++) {
		h_arr1[i]=i+1;
		h_arr2[i]=i+2;
	}

	//device memory
	float *d_arr1,*d_arr2;

	//allocate device memory
	cudaMalloc((void**)&d_arr1,size);
	cudaMalloc((void**)&d_arr2,size);

	//copy host to device
	cudaMemcpy(d_arr1,h_arr1,size,cudaMemcpyHostToDevice);
	cudaMemcpy(d_arr2,h_arr2,size,cudaMemcpyHostToDevice);

	addKernel<<<8,8>>>(d_arr1,d_arr2);


	//copy result device to host
	cudaMemcpy(h_res,d_arr1,size,cudaMemcpyDeviceToHost);

	//print result array
	for(int i=10;i<20;i++)
		cout << h_arr1[i] << " ";
	cout << endl;

	for(int i=10;i<20;i++)
		cout << h_arr2[i] << " ";
	cout << endl;

	for(int i=10;i<20;i++)
		cout << h_res[i] << " ";
	cout << endl;

	//free host and device memory
	free(h_arr1); free(h_arr2); free(h_res);
	cudaFree(d_arr1); cudaFree(d_arr2);
}
