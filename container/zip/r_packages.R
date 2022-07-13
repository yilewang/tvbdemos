require(devtools)

Sys.setenv(TAR = "/bin/tar")

install_version("Matrix", dependencies=TRUE, version="1.2-11", repos="https://cloud.r-project.org")
install_version("survival", dependencies=TRUE, version="2.41-3", repos="https://cloud.r-project.org")
install_version("TH.data", dependencies=TRUE, version="1.0-8", repos="https://cloud.r-project.org")
install_version("mvtnorm", dependencies=TRUE, version="1.0-5", repos="https://cloud.r-project.org")
install_version("multcomp", dependencies=TRUE, version="1.4-3", repos="https://cloud.r-project.org")
install_version("e1071", dependencies=TRUE, version="1.6-8", repos="https://cloud.r-project.org")
install_version("coin", dependencies=TRUE, version="1.1-3", repos="https://cloud.r-project.org")
install_version("party", dependencies=TRUE, version="1.0-25", repos="https://cloud.r-project.org")
