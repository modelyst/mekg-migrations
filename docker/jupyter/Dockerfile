FROM jupyter/scipy-notebook:latest
# Install in the default python3 environment
COPY --chown=${NB_UID}:${NB_GID} docker/jupyter/requirements.txt /tmp/
RUN pip install --quiet --no-cache-dir --requirement /tmp/requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
