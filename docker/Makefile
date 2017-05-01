WORK_DIR:=$(shell readlink -f $(dir $(lastword $(MAKEFILE_LIST))))

default:
	cd $(WORK_DIR) ; docker build -t yijinliu/objc:`date '+%Y-%m-%d'` .
