# Datalakehouse on Kubernetes

Bu proje, Trino, Nessie, Jupyter Spark ve MinIO gibi bileşenlerle tam bir veri gölü mimarisi sunar. Tüm bileşenler Kubernetes üzerinde Helm chartları ile yönetilir.

## İçerik

- **charts/**: Her bileşenin Helm chartları (`trino`, `nessie`, `minio`, `jupyter-spark`)
- **airflow/**: Airflow için özel değerler ve gizli anahtarlar (`org_values.yaml`, `secret.yaml`)
- **values.yaml**: Ana bileşenlerin yapılandırma değerleri
- **Chart.yaml**: Ana Helm chart tanımı

## Bileşenler

- **Trino**: SQL sorguları için dağıtık sorgu motoru
- **Nessie**: Veri gölü için git-benzeri versiyon kontrolü
- **MinIO**: S3 uyumlu nesne depolama
- **Jupyter Spark**: Veri analizi ve notebook ortamı
- **Airflow**: Veri boru hattı orkestrasyonu

## Kurulum

1. **Bağımlılıkları güncelleyin:**
   ```sh
   helm dependency update .
   helm dependency build .
   ```

2. **Minikube veya başka bir Kubernetes ortamı başlatın:**
   ```sh
   minikube start --driver=docker --cpus=4 --memory=9500 --disk-size=40g
   ```

3. **Proje bileşenlerini yükleyin:**
   ```sh
   helm upgrade --install datalakehouse ./ -n default
   ```
4. **Airflow Başlatma**

   ```sh
    helm upgrade --install airflow apache-airflow/airflow -n airflow -f  .\airflow\org_values.yaml --debug --timeout 10m02s
   ```
## Git Sync Konfigürasyonu

Proje içinde git-sync ile bir repository'den dosya çekmek için aşağıdaki örnek değerleri kullanabilirsiniz:

```yaml
gitSync:
  enabled: true
  repo: "https://github.com/kullanici/proje-repo.git"
  branch: "main"
  rev: "HEAD"
  depth: 1
  wait: 30
  root: "/git"
  dest: "repo"
  username: ""
  password: ""
```
```sh
minikube kubectl -- apply -f ./airflow/secret.yaml --namespace airflow


minikube kubectl -- get secret git-credentials -o yaml -n airflow
```

## Servis Portları

- MinIO: `9000` (API), `9001` (Konsol)
- Trino: `8081`
- Nessie: `19120`
- Jupyter Spark: `8888`
- Airflow: `8080`

## Örnek Port Forward Komutları

```sh
minikube kubectl -- port-forward svc/datalakehouse-minio-console 9001:9001
minikube kubectl -- port-forward svc/trino 8081:8081
minikube kubectl -- port-forward svc/jupyter-spark-svc 8888:8888
minikube kubectl -- port-forward svc/nessie 19120:19120
minikube kubectl -- port-forward svc/airflow-api-server 8080:8080 --namespace airflow2
```

## Notlar

- Airflow için `airflow/secret.yaml` dosyasını oluşturup uygulamanız gerekir.
- Her bileşenin yapılandırması için `values.yaml` dosyasını düzenleyebilirsiniz.
- Gerekli Docker imajlarını önceden yüklemek için:
  ```sh
  minikube ssh "docker pull ghcr.io/projectnessie/nessie:0.104.3"
  minikube image load ghcr.io/projectnessie/nessie:0.104.3
  ```

## Kaynaklar

- [Trino](https://trino.io/)
- [Nessie](https://projectnessie.org/)
- [MinIO](https://min.io/)
- [Jupyter](https://jupyter.org/)
- [Airflow](https://airflow.apache.org/)
