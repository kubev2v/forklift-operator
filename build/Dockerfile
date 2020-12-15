FROM quay.io/operator-framework/ansible-operator:v0.19.4

WORKDIR /opt/ansible
COPY requirements.yml requirements.yml
RUN ansible-galaxy collection install -r requirements.yml

COPY watches.yaml watches.yaml
COPY roles/ roles/
