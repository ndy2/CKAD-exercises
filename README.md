# CKAD-exercises

Let's practice [CKAD](https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/) questions.

- [Curriculum 1.21](curriculum-1.21)
- [Curriculum 1.29](curriculum-1.29)

---

## 1. Certified Kubernetes Application Developer
- Exam Fee: $395 → Let’s catch a discount!
- Exam Duration: 2 hours
- Certification Validity: 2 years
- Total Questions: 16-20, Maximum Score: 100, Passing Score: 66 or above
- Access to resources like kubernetes.io/docs is allowed

## 2. Curriculum
- See [Curriculum 1.29](curriculum-1.29)

## 3. Question Example
**Question**
- Deploy a nginx image as a Deployment in the namespace hello.
- Set the number of replicas to 3,
- and mount an empty directory at the path /etc/volume.
- The name of the Deployment should be `nginx-deploy`.

**Answer**

```bash
k create deploy nginx-deploy -n hello - image=nginx --replica=3 --dry-run=client -o yaml > deploy.yaml
```

```yaml
  1 apiVersion: apps/v1
  2 kind: Deployment
  3 metadata:
  4   creationTimestamp: null
  5   labels:
  6     app: nginx-deploy
  7   name: nginx-deploy
  8   namespace: hello
  9 spec:
 10   replicas: 3
 11   selector:
 12     matchLabels:
 13       app: nginx-deploy
 14   strategy: {}
 15   template:
 16     metadata:
 17       creationTimestamp: null
 18       labels:
 19         app: nginx-deploy
 20     spec:
 21       containers:
 22       - image: nginx
 23         name: nginx
 24         resources: {}
 25         volumeMounts:             ## add this part
 26         - name: volume
 27           mountPath: /etc/volume
 28       volumes:                    ## add this part
 29       - name: volume
 30         emptyDir: {}
 31 status: {}       
```

```
k create -f deploy.yaml
```

## 4. How to Practice

Summary
- kubernetes.io/docs

Hands-on Practice!
- Udemy → CKAD, KodeKloud environment
- Various GitHub resources → MicroK8s
- killers.sh

## 5. Tips

### A. Short on Time
- Resolve as much as possible using kubectl.
- For tasks requiring a search, organize resources to quickly find what’s needed.

Examples:
- You can’t create PVs or PVCs with kubectl alone - quickly search on kubernetes.io/docs and grab the YAML.
- When creating a deployment with kubectl, you can’t set env variables, volumes, etc.
- Memorize what’s necessary - quickly find the rest in the documentation.
- Don’t memorize the exact keys for setting secrets/env as env or mount in YAML - they vary slightly different.

### B. Script

```
echo "set ai" >> .vimrc
echo "set nu" >> .vimrc
echo "tabstop=2 shitwidth=2 expandtab" >> .vimrc

do="--dry-run=client -o yaml"
ka="kubectl apply -f"
```

Run this script in every question (ssh enter)

### C. A good camera and your passport properly organized.
Items to Prepare
	- A good camera
	- Passport
	- An organized workspace

## 6. Some Commands that I'd learn
- kubectl scale
  - k scale deployment metaservice --replicas=3 
- kubectl set image
  - k set image deploy/metaservice metaservice=abis.ahnlab.com/..../metaservice/1.0.x.x
- kubectl number expression
 - k get nodes akw{0..9}
- kubectl get ep
- kubectl explain
  - k explain pod.spec 
- kubectl wait
  - k wait --for=condition=Ready pod/busybox1
- helm update -i
- helm install/update --set
