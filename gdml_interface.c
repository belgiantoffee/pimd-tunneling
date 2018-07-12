#include <Python.h>
#include "gdml.h"

void gdml_setup() {
	Py_Initialize();
	initgdml();

	GDML_load();
}

void gdml_predict(int* ndof,double* crds, double* grad, double* energy)
{
    gdml_predict_py(crds, grad, energy);
}

void gdml_finalize() {
	Py_Finalize();
}

/*int main() {

	int n_atoms = 21;
	int size = 3*n_atoms;
	
    double* coords = malloc(sizeof(double)*size);
	double aspirin[] = {1.799771,-1.365083,-0.630185,0.722243,0.999986,-1.770019,2.474230,-0.740034,-1.677192,1.854607,0.401006,-2.234357,-2.620110,2.259268,1.056162,0.589713,-0.846861,-0.111782,0.049705,0.352781,-0.725756,-1.059850,-1.113643,1.757885,-0.142517,2.053496,1.279454,-0.033987,-2.952151,0.813408,-0.222698,-1.587695,0.914565,-1.194847,1.774661,0.675071,-1.283003,0.853656,-0.305935,-0.572676,-3.421412,1.498483,2.328545,-2.109331,-0.018390,0.277012,1.962643,-2.147693,3.347982,-1.138995,-2.190922,2.390196,1.052133,-2.940848,-2.595256,3.176753,1.759707,-3.175607,2.720297,0.171504,-3.148330,1.282830,1.263961};
	memcpy(coords, aspirin,sizeof(double)*size);
  
	double* grad = malloc(sizeof(double)*size);
	double energy;
	
	gdml_setup();
	gdml_predict(coords, grad, &energy);

	printf("energy: %f\n",energy);
	for (int a=0; a<n_atoms; a++)
		printf("%f %f %f\n",grad[a],grad[a+n_atoms],grad[a+2*n_atoms]);

	gdml_finalize();
	return 0;
}*/
