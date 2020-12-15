FROM quay.io/operator-framework/ansible-operator:v1.2.0

COPY requirements.yml requirements.yml
RUN ansible-galaxy collection install -r requirements.yml

COPY watches.yaml watches.yaml
COPY roles/ roles/
