# Optional: build a self-contained branded image instead of mounting the
# ConfigMap. Useful when you want to push to your own registry.
#
#   docker build -t <registry>/kubetraffic-nginx:0.1.0 .
#   docker push  <registry>/kubetraffic-nginx:0.1.0
#
# Then update manifests/deployment.yml (or helm values) to use that image and
# remove the nginx-content ConfigMap + volume mount.
FROM nginx:1.27-alpine
COPY config/nginx-content.html /usr/share/nginx/html/index.html
EXPOSE 80
