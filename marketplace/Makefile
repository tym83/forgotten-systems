# Каталог «Забытые системы» для Cozystack.
#
# Единица установки — репозиторий целиком, а не отдельный пакет: вещи внутри
# собраны и проверены вместе. Репозиториев три, у каждого свой OCI-артефакт и
# своя запись в метаиндексе.

COZYPKG ?= /tmp/cozypkg
REGISTRY ?= ghcr.io/tym83/paleocomputing
TAG      ?= v0.1.0
REPOS    := machines languages images

.PHONY: help check validate gen search push clean-check

help:
	@echo "  make check      все проверки каталога (включая мутации)"
	@echo "  make validate   только штатный валидатор Cozystack по каждому репозиторию"
	@echo "  make gen        пересобрать описания приложений из схем чартов"
	@echo "  make search     показать метаиндекс глазами cozypkg"
	@echo "  make push       выложить репозитории в OCI (нужен свой REGISTRY=)"

check:
	@python3 tools/check.py

# Штатный валидатор Cozystack. Каждый репозиторий проверяется отдельно:
# корень артефакта у него свой.
#
# --helm-lint не включаем намеренно: helm 4 считает ошибкой путь к иконке вида
# /logos/foo.svg, а это конвенция самого Cozystack (hack/update-crd.sh
# разрешает такой путь внутрь чарта). На их собственных чартах — nats, redis,
# kafka, mongodb — helm 4 ругается ровно так же.
validate:
	@for r in $(REPOS); do \
	  echo "── repos/$$r"; \
	  $(COZYPKG) validate repos/$$r || exit 1; \
	done

gen:
	@for d in repos/*/packages/system/*-rd; do \
	  [ -f "$$d/appdefs.yaml" ] || continue; \
	  echo "── $$d"; python3 tools/gen-appdefs.py "$$d" || exit 1; \
	done

search:
	@$(COZYPKG) search --index index

# Публикация. Каждый репозиторий уезжает отдельным артефактом под своим тегом:
# тег и есть версия репозитория, им же он приколачивается при подключении.
push:
	@for r in $(REPOS); do \
	  echo "── repos/$$r -> oci://$(REGISTRY)/$$r:$(TAG)"; \
	  $(COZYPKG) push oci://$(REGISTRY)/$$r:$(TAG) --path repos/$$r || exit 1; \
	done
