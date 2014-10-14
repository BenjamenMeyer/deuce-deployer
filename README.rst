==============
deuce-deployer
==============

Show off how simple it can be to deploy Deuce

To deploy with uWSGI simply run:

.. code-block:: bash

    $ ./build_deployment.sh uwsgi
  
To deploy with gunicorn simply run:

.. code-block:: bash

    $ ./build_deployment.sh gunicorn

These build Python Virtual Environments in the local directory that are usable.
Access the Deployment environment and start the system as you like:

.. code-block:: bash

    $ bash
    $ source uwsgi_deuce_deployment/bin/activate
    $ deuce-server
  
or

.. code-block:: bash

    $ bash
    $ source uwsgi_deuce_deployment/bin/activate
    $ uwsgi --ini uwsgi/uwsgi_deuce.ini
  
