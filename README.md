这个项目是用于演示如何用argocd来部署和管理一个CI的环境，需要部署的工具如下：

- metallb: k8s的lb工具。
- traefik: 反向代理工具，用于ingress的实现。
- cert-manager: 证书签发工具。
- vault: 密钥管理工具。
- external-secrets: 可以将外部的密钥同步为k8s的secret。
- vcluster: 可以在物理k8s集群中创建虚拟集群的工具。
- argo-events: 提供事件监听、转换和触发的工具。
- tekton: k8s原生的流水线工具。

首先需要准备一个k8s集群和一个vault实例，然后按照以下步骤进行部署（所需的命令行在cmds目录下）：

1. 在vault中创建一个secret用于存放cert-manger所需的证书和私钥。
2. 手动在集群中安装argocd以及argocd-server的patch。
3. 将项目根目录的project.yaml和app.yaml安装到集群中。
4. argocd会根据配置在物理集群中安装metallb、traefik、cert-manager、vault（包括认证所需的sa）、external-secrets、并创建一个vcluster，等待初始化完成。
5. 在vault中创建一个kubernetes认证，填写物理机群的api-server地址、ca证书、认证sa的token。然后在此认证下创建保存了cert-manger私钥的secret的访问权限。
6. 通过vcluster命名空间下的secret生成用于访问虚拟集群的kubeconfig文件，并修改server字段中的ip、端口、cluster名称等。
7. 通过argocd命令行使用kubeconfig文件向argocd注册新创建的虚拟集群。
8. 物理集群的argocd自动向虚拟集群中部署argocd，以及用于虚拟集群内部初始化所需的project和app资源。
9. 等待虚拟集群内部的argocd完成所有工具的部署，包括：argo-events、tekton、traefik、vault、external-secrets。