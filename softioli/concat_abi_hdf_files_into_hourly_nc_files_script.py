import argparse
import pathlib

from utils.sat_utils import generate_abi_hourly_nc_file_from_15min_hdf_files
from common.utils import list_from_file

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Concatenate 15-min ABI HDF4 files into hourly pre-regrid netCDF files. '
    )

    path_list_group = parser.add_mutually_exclusive_group(required=True)
    path_list_group.add_argument('--dir-list', help='Path to txt file containing list of daily directory paths to concat (1 path/line)')
    path_list_group.add_argument('--dir-path', help='Path to a single daily directory to concat (useful when running via a slurm array)')

    parser.add_argument('-d', '--print-debug', action='store_true')

    parser.add_argument('--overwrite', '-o', action='store_true',
                        help='indicates if hourly pre-regrid file should be overwritten if it already exists')
    parser.add_argument('--rm-temp-files', action='store_true',
                        help='Indicates if the temp/ directory containing the raw 15-min HDF4 files should be '
                             'deleted once all hourly files for that directory have been generated (to save some space)')

    args = parser.parse_args()
    print(args)

    if args.dir_list:  # txt file with several directory paths
        dir_path_list = [pathlib.Path(d_path) for d_path in list_from_file(args.dir_list, header=0, ignore_blank_lines=True)]
    else:  # directly path to directory
        dir_path_list = [pathlib.Path(args.dir_path)]

    if args.print_debug:
        print(f"launching generate_abi_hourly_nc_file_from_15min_hdf_files on: {dir_path_list}")

    generate_abi_hourly_nc_file_from_15min_hdf_files(
        dir_path_list=dir_path_list,
        remove_temp_files=args.rm_temp_files,
        overwrite=args.overwrite,
        print_debug=args.print_debug,
    )

    print("end of file: concat_abi_hourly_script")

