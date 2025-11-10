# Technical Architecture Design Document

## 1. Overview and Assumptions

This document proposes a high level design for a photo based communication tool for large manufacturing companies. The system enables workers to upload images, annotate them with simple markup, and start message threads. Engineers and procurement can respond in real time.

**Key assumptions**:

* Target users are 500+ employee manufacturing companies with moderate security expectations.
* CADDi's current stack is primarily TypeScript, React, and AWS. The design aligns with existing platform choices.
* Initial build must validate product value quickly, so managed services are preferred.

## 2. High Level Architecture

### 2.1 Architecture Diagram (ASCII)

```
                +-----------------------+
                |       Frontend        |
                |  React Web Client     |
                +-----------+-----------+
                            |
                            v
                +-----------+-----------+
                |    API Gateway /      |
                |  Backend Service (ECS)|
                +-----------+-----------+
                            |
        +-------------------+--------------------+
        |                                        |
        v                                        v
+---------------+                    +------------------------+
|  RDS          |                    |   S3 (Image Storage)   |
| PostgreSQL    |                    | + CloudFront CDN       |
+---------------+                    +-----------+------------+
                                                    |
                                                    v
                                         +----------------------+
                                         | Lambda (Thumbnails & |
                                         |  Annotation Overlay) |
                                         +----------+-----------+
                                                    |
                                                    v
                                         +----------------------+
                                         | SNS/SQS Notifications|
                                         +----------------------+
```

### 2.2 Data Model Diagram (ASCII ERD)

```
+---------+        1        +-------------+        1        +-----------+
|  Photo  |---------------->| Annotation  |----------------->|  Thread   |
+---------+                 +-------------+                  +-----------+
     |                            |                                |
     |                            |                                |
     |                            |                                |  N
     |                            |                                v
     |                            |                        +-------------+
     |                            |                        |   Message   |
     |                            |                        +-------------+
     |                            |
     |                            |
     +----------- N -------------+
```

**Components**:

* Web client (React)
* Backend API (Node.js + NestJS or Fastify)
* Image storage + CDN (Amazon S3 + CloudFront)
* Annotation service (backend service handling markup overlays)
* Message thread service
* Authentication (Amazon Cognito)
* Database (Amazon RDS PostgreSQL)
* Event and notification service (SNS/SQS)
* Monitoring (CloudWatch + Datadog)

**Architecture flow**:

1. User authenticates via Cognito.
2. Client uploads raw image to S3 using pre signed URL.
3. Client sends annotation coordinates + text to API.
4. Backend stores metadata and message threads in PostgreSQL.
5. Annotated previews generated via server side Lambda.
6. Notification events pushed to interested users.
7. CDN serves images.

## 3. Technical Stack

* **Frontend**: React, TypeScript, Tailwind, React Query
* **Backend**: Node.js + NestJS, TypeScript
* **Database**: PostgreSQL (RDS), with structured schema
* **Storage**: S3, CloudFront
* **Runtime**: ECS Fargate (preferred for speed), Lambda for light image operations
* **Infra**: Terraform
* **Messaging**: SNS/SQS
* **Auth**: Cognito (OIDC, SAML support for enterprises)

## 4. Data Model (Simplified)

### Entities

* **User**
* **Photo**
* **Annotation**
* **Thread**
* **Message**

### ER Structure

* User (1) — (N) Thread
* Thread (1) — (N) Message
* Photo (1) — (N) Annotation
* Annotation (1) — (1) Thread (optional if each annotation opens a thread)

**Photo**: id, s3_url, uploaded_by, created_at

**Annotation**: id, photo_id, type, coordinates, created_by

**Thread**: id, annotation_id, created_by

**Message**: id, thread_id, body, created_by, created_at

## 5. Key Design Decisions

### Managed services over self hosted

Reason: team size is small, and speed is critical. AWS managed services reduce operational overhead.

### RDS over DynamoDB

Reason: threads and annotations are relational, and query patterns are predictable.

### CDN + S3 rather than in app delivery

Reason: images will be large; CDN reduces backend load and improves user experience.

### Use pre signed uploads

Reason: prevents backend from handling heavy uploads and speeds up user flow.

## 6. Non Functional Requirements

### Security

* S3 bucket policies with object level ACLs.
* Signed URLs for uploads and downloads.
* Cognito enforcing MFA + SSO options.
* Encryption at rest (S3 + RDS).
* VPC isolation for services.

### Performance

* Target <200 ms API latency for metadata operations.
* CDN caching for photo reads.
* Asynchronous generation of thumbnails.

### DevOps + CI/CD

* GitHub Actions pipelines for build, test, deploy.
* Terraform for infra consistency.
* Canary deployments for backend.

### Testing

* Unit tests for backend logic.
* Integration tests for annotation pipeline.
* UI snapshot tests.

### Monitoring

* Datadog dashboards for API latency, error rates.
* CloudWatch alarms for RDS, S3 errors, and Lambda failures.

## 7. Trade offs

* Using managed services increases cost slightly but saves engineering time.
* Early versions may skip advanced real time collaboration to meet time pressure.
* Annotation tool kept simple initially to speed delivery.

## 8. Initial Team and Timeline

### Team

* 1 backend engineer
* 1 frontend engineer
* 1 infra engineer (partial)

### Rough Plan (6 weeks)

* Week 1: Infra, auth, S3, schema
* Week 2: Upload pipeline, annotation basics
* Week 3: Threading + messaging API
* Week 4: Frontend integration
* Week 5: Notifications, thumbnails
* Week 6: Stabilization and demo

## 9. Conclusion

This design focuses on speed, clarity, and leveraging AWS managed services. It offers a scalable foundation while supporting rapid exploration of the new product idea.
