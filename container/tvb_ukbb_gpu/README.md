## Basic Singularity Container Tutorial

To create a sandbox (writable directory)


```bash
sudo singularity build --sandbox tvb-ukbb-hsam.sif sing.def
```

To run the container

```bash
singularity run tvb-ukbb-hsam.sif <subjectdir>
```

