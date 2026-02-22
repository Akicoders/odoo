FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
    libpq-dev libjpeg-dev libfreetype6-dev \
    node-less npm git \
    wkhtmltopdf \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -u 1000 -s /bin/bash odoo

WORKDIR /odoo

COPY --chown=odoo:odoo requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=odoo:odoo . .

RUN mkdir -p /var/lib/odoo /var/log/odoo && \
    chown -R odoo:odoo /var/lib/odoo /var/log/odoo

RUN touch /etc/odoo/odoo.conf && chown odoo:odoo /etc/odoo/odoo.conf
COPY --chown=odoo:odoo debian/odoo.conf /etc/odoo/odoo.conf

USER odoo
EXPOSE 8069 8071 8072

CMD ["python", "odoo-bin", "--config=/etc/odoo/odoo.conf"]
