from diagrams import Diagram, Cluster

from diagrams.onprem.network import Nginx, Tomcat
from diagrams.onprem.database import Postgresql
from diagrams.onprem.client import User
from diagrams.onprem.container import Docker

with Diagram("", show=False, direction="TB", filename="infrastructure"):
    user = User("Web Browser")
    nginx = Nginx("Nginx")
    
    with Cluster("Behind Nginx"):
        db = Postgresql("PG-DB")
        tc = Tomcat("GeoServer")
        django = Docker("DJango")

    user >> nginx >> [django, tc]
    django >> db

