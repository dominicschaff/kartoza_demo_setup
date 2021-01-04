from diagrams import Diagram, Cluster

from diagrams.onprem.network import Nginx, Tomcat
from diagrams.onprem.database import Postgresql
from diagrams.onprem.client import User
from diagrams.onprem.container import Docker

with Diagram("", show=False, filename="infrastructure"):
    user = User("Web Browser")
    nginx = Nginx("Nginx")

    db = Postgresql("PG-DB")
    web = Docker("RedMine")

    user >> nginx >> web >> db

