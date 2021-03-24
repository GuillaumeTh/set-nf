#!/usr/bin/env bash
usage() { echo "$(basename $0) [-i tractoflow] [-o output]" 1>&2; exit 1; }

while getopts "i:o:" args; do
    case "${args}" in
        i) i=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${i}" ] || [ -z "${o}" ]; then
    usage
fi

TFINDIR=$(readlink -m ${i})
OUTDIR=$(readlink -m ${o})

echo "Tractoflow/results folder: ${TFINDIR}"
echo "Output folder: ${OUTDIR}"

echo "Building tree..."
cd ${TFINDIR}
for i in *;
do
    mkdir -p ${OUTDIR}/${i}

    # Tractoflow folders
    for cfile in fa.nii.gz;
    do
        if [ -f ${TFINDIR}/${i}/DTI_Metrics/*${cfile} ]; then
            cp -L ${TFINDIR}/${i}/DTI_Metrics/*${cfile}  ${OUTDIR}/${i}/
        else
            echo "WARNING! ${i} ${cfile} was not found"
        fi
    done

    for cfile in fodf.nii.gz;
    do
        if [ -f ${TFINDIR}/${i}/FODF_Metrics/*${cfile} ]; then
            cp -L ${TFINDIR}/${i}/FODF_Metrics/*${cfile}  ${OUTDIR}/${i}/
        else
            echo "WARNING! ${i} ${cfile} was not found"
        fi
    done

    for cfile in map_exclude.nii.gz map_include.nii.gz;
    do
        if [ -f ${TFINDIR}/${i}/PFT_Maps/*${cfile} ]; then
            cp -L ${TFINDIR}/${i}/PFT_Maps/*${cfile}  ${OUTDIR}/${i}/
        else
            echo "WARNING! ${i} ${cfile} was not found"
        fi
    done

    for cfile in output0GenericAffine.mat output1InverseWarp.nii.gz;
    do
        if [ -f ${TFINDIR}/${i}/Register_T1/*${cfile} ]; then
            cp -L ${TFINDIR}/${i}/Register_T1/*${cfile}  ${OUTDIR}/${i}/
        else
            echo "WARNING! ${i} ${cfile} was not found"
        fi
    done

done
echo "Done"
