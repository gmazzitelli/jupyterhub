### procedera per il setup 
#
- cvmfs_server transaction sft-cygno.infn.it
- cd /usr/local/share/dodasts/jupyterhub/CYGNO/package
- docker-compose up -d
- docker exec -it py_assets bash
- export PYTHONPATH="/mnt/py/Ubuntu22.04_Py3.11.9"
- intslla qualcosa (es '''pip install boto3==1.35.95 -t $PYTHONPATH/''')
- exit from docker py_assets
- docker-compose down
- cvmfs_server publish sft-cygno.infn.it


quindi per non sbagliarsi 
'''
 cvmfs_server transaction sft-cygno.infn.it; docker-compose up -d; docker exec -it py_assets bash
 pip install ... -t $PYTHONPATH/
 docker-compose down ; cvmfs_server publish sft-cygno.infn.it
'''
in boca la lupo...

