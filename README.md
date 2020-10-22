# abap-log-exporter :construction: WIP

[![Known Vulnerabilities](https://snyk.io/test/github/Goala/abap-log-exporter/badge.svg?targetFile=package.json)](https://snyk.io/test/github/Goala/abap-log-exporter?targetFile=package.json)
![GitHub package.json dependency version (dev dep on branch)](https://img.shields.io/github/package-json/dependency-version/Goala/abap-log-exporter/dev/@abaplint/cli)
![Run abaplint](https://github.com/Goala/abap-log-exporter/workflows/Run%20abaplint/badge.svg)

# architecture

![architecture](./out/architecture/architecture/architecture.png)

# customizing

Different scenarios can be customized in the table ZALE_CONFIG. This are the fields for each sceanrio

| Field           | Description                         |
| ----------------|-------------------------------------|
| READER_CLASS    | class for the reader component      |
| CONVERTER_CLASS | class for the converter component   |
| CONNECTOR_URL   | URL to the log tool e.g. GrayLog    |
| CONNECTOR_CLASS | class fot the connector component   |



# local tests

https://github.com/JohannesKonings/docker-abap-log-exporter-tester

:warning: instead of localhost the URLs have to be customized with the IP of the Ethernet Adapter
