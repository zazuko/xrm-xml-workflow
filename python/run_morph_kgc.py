import subprocess
import sys

def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

install('morph_kgc')

import morph_kgc

def write_file(mapping_file, output_file ):
    config = f"""
                 [CONFIGURATION]
                 na_values: #N/A,,N/A

                 [MAPPING]
                 mappings: {mapping_file}
             """
    g = morph_kgc.materialize(config)
    g.serialize(output_file, format="n3")

    return len(g)
