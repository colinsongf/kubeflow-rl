local params = std.extVar("__ksonnet/params").components["jupyter-iap"];
// TODO(https://github.com/ksonnet/ksonnet/issues/222): We have to add namespace as an explicit parameter
// because ksonnet doesn't support inheriting it from the environment yet.

local k = import 'k.libsonnet';
local iap = import "kubeflow/core/iap.libsonnet";

local namespace = params.namespace;
local certsSecretName = params.certsSecretName;


// Selector that matches the tf-hub pods.
local jupyterHubSelector = 	{
		"app": "tf-hub",
};

// Name to use for the K8s resources created.
local partName = "jupyter-hub";

// This will be the port JupyterHub's ESP proxy is listening on. Keep this in sync with the value in jupyterhub.libsonnet
local jupyterHubEspPort = 9000;

std.prune(k.core.v1.list.new([
	// jupyterHub components
	iap.parts(namespace, partName).iapEspProxyService(jupyterHubSelector, jupyterHubEspPort),
	iap.parts(namespace, partName).ingress(certsSecretName),    
]))
