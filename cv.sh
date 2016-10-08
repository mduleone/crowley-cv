#!/bin/bash

#=====================================================================
#          FILE:  cv.sh
#         USAGE:  Run manually to generate my CV
#   DESCRIPTION:  Uses Pandoc to pull together Markdown documents
#                 & process them with Pandoc to generate my CV
#        AUTHOR:  Scott Granneman (RSG), scott@ChainsawOnATireSwing.com
#       VERSION:  0.2
#       CREATED:  05/11/2013 11:50:30 CDT
#      REVISION:  05/15/2013 09:59:30 CDT
#=====================================================================

###
## Variables
#

# Directory for CV
cvDir=./output

# Directory for CV Builds
cvBuildDir=./Builds

# Name of the CV file
cvName="Andrew Crowley - CV - $(date +%Y-%m-%d)"
cvFileName="Andrew_Crowley_CV_$(date +%Y_%m_%d)"

#Path to .tex file
texFile='crowley.tex'

#Path to css file
cssFile='crowley.css'

#File Output Directory

###
## Create HTML files for each Markdown file
#

for i in $(ls $cvBuildDir/*md) ; do
  echo $i
  # Get the name of the file, sans extension, for generating HTML file
  cvBuildName=$(basename "$i" .md)
  # Convert to HTML
  pandoc --section-divs -f markdown -t html5 -o $cvBuildDir/$cvBuildName.html $i
done

###
## Join the HTML files into one HTML CV
#

pandoc -s -H $cvBuildDir/$cssFile --section-divs -f markdown -t html5 \
-o "$cvDir/$cvName.html" \
-A $cvBuildDir/description.html \
-A $cvBuildDir/education.html \
-A $cvBuildDir/experience.html \
-A $cvBuildDir/qualifications.html \
-A $cvBuildDir/interests.html \
-A $cvBuildDir/references.html \
-A $cvBuildDir/skills.html \
$cvBuildDir/cv.md

###
## Convert the HTML CV into PDF CV
#

pandoc -H $cvBuildDir/$texFile "$cvDir/$cvName.html" -o "$cvDir/$(echo $cvFileName).pdf"

###
## References
#

# Convert to HTML
pandoc --section-divs -f markdown -t html5 -o "$cvBuildDir/references.html" "$cvBuildDir/references.md"

# Convert HTML to PDF
pandoc -H $cvBuildDir/$texFile "$cvBuildDir/references.html" -o "$cvDir/$(echo $cvFileName).pdf"

###
## Cover Letter
#

# Convert to HTML
pandoc --section-divs -f markdown -t html5 -o "$cvBuildDir/cover-letter.html" "$cvBuildDir/cover-letter.md"

# Convert HTML to PDF
pandoc -H $cvBuildDir/$texFile "$cvBuildDir/cover-letter.html" -o "$cvDir/$(echo $cvFileName).pdf"
