# The test script of FSL

I made two scripts for test run of fsl in europa:

- The first one is `fsl_edd_dMRI.sh`, and the required files are stored at `dMRI/dMRI` directory. This one is running `eddy_openmp` to do parallel computing using CPU.
- The second one is 'fsl_fnirt_struct.sh`, and the required files are stored at `struct` directory. This one is a *normal* fsl command, without any special deployment of `openmp`.

Please let me know if you have any questions!!!
