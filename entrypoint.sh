#!/bin/sh

eval "/opt/live_k8s/bin/live_k8s eval \"LiveK8s.Release.migrate()\""

exec /opt/live_k8s/bin/live_k8s start