import subprocess
import os
import glob

# extract project name and run name from the hierarchal directory organization
fullDir = os.getcwd()
dirList = fullDir.split('/')
run_name = dirList[4] + "/"
proj_name = dirList[3] + "/"

# find directories with output
outputFiles = glob.glob("*output*")

# transfer outputs to S3
def toS3():
  for i in outputFiles:
    curDir = i + "/"
    cmd_str = "aws s3 cp --recursive " + curDir + " s3://viralrecon/" + proj_name + run_name + curDir
    try:
      subprocess.run(cmd_str, shell=True)
    except:
      pass

toS3()
