# Technical Architecture Design Document

## 1. Overview and Assumptions

This document proposes a high level design for a photo based communication tool for large manufacturing companies. The system enables workers to upload images, annotate them with simple markup, and start message threads. Engineers and procurement can respond in real time.

**Key assumptions**:

* Target users are 500+ employee manufacturing companies with moderate security expectations.
* CADDi's current stack is primarily TypeScript, React, and AWS. The design aligns with existing platform choices.
* Initial build must validate product value quickly, so managed services are preferred.

## 2. High Level Architecture

### 2.1 Infra Diagram
<img width="992" height="564" alt="image" src="https://github.com/user-attachments/assets/6e0518d3-e7f2-40c7-b509-dada22cc645d" />

### 2.2 Various flows 

#### 2.2.1 Send image to server
<img width="1057" height="312" alt="image" src="https://github.com/user-attachments/assets/833120bb-d0a2-412c-b2fd-2142386fa6c5" />

1. User capture and sends image to server with meta information like name and description
2. API gateway authenticate user and forwards request to PUT /v1/image
3. Web server saves image in to s3 with temporary name
4. Successful save  move flow forward or flow goes to point 8 to send error message to client
5. API creates record entry into DB for the image (in db image is stored along with the name 
and description provided)
    5.1 Image information along with meta data will be stored in the elastic search for faster retrieval
6. DB gives unique id/name for the image
7. image is rename using id from temporary name in the s3
8. API responds with request id
9. Client gets the successfully image id

 
#### 2.2.2 Permission to other users

<img width="986" height="342" alt="image" src="https://github.com/user-attachments/assets/5cd70d94-ef90-4fd0-ad0e-9c2006c04d9b" />

1. User send image id and users ids for which permission to be given
2. Post auth verification request will be given to web server
3. Web server makes entry in the DB for permission mapping records
4. successful commit responds to API code
5. Web server queues the message to be send to users with image permissions
6. Notification service consumes payload from message queue and sends notification
7. Client get confirmation about processing of request


#### 2.2.3 Get image

<img width="789" height="301" alt="image" src="https://github.com/user-attachments/assets/5854d98e-ddd1-45ad-bd64-40fa2758b3aa" />

1. User use keyword to search image. 
2. Request authenticated
3. Long text search in the Elastic Search
4. Search results with list of records. Each record will have image id as tag
5. Image list response to gateway
6. Image list response to user
7. User choose to id and send get image request
8. Gateway authenticate and authorize the request
9. API asks db for S3 path for given image id
10. receive s3 path
11. Requests to s3 to create temporary path for download
12. path returned
13. Path give to gatway as response
14. Client gets temporary image path in response
15. client starts the image download
    
#### 2.2.4 Annotate and Start message thread

<img width="742" height="373" alt="image" src="https://github.com/user-attachments/assets/f382eacf-1c94-47b7-9780-a0e40de572e7" />

1. User selects the circle on the image. 
The location of the circle as pixel along with radius is given to web server 
2. Web server makes entry into chat table for the image id along with circle information
3. Generated chat id is received by web server along with all the user having permission to image
4. Chat id is cached along empty message list
5.  Chat id link is generated and notification payload generated and queued in message queue to send to
    users with permission
6. Notifier process image and inform other users about start of chat

#### 2.2.5 Collaboration
<img width="764" height="376" alt="image" src="https://github.com/user-attachments/assets/2daacb8c-e9a9-4642-8dbf-6f8807a949f9" />

1. Client 1 retrieve the chat and adds message
2. Web server caches message 
3. Sends copy of message to client 2
4. Stores message in the DB for permanent storage

## 3. Technical Stack

* **Frontend**: React, TypeScript
* **Backend**: Node.js + NestJS, TypeScript
* **Database**: PostgreSQL (RDS), with structured schema
* **Storage**: S3, CloudFront
* **Infra**: Terraform
* **Messaging**: SNS/SQS
* **Auth**: Cognito (OIDC, SAML support for enterprises) at API Gateway

## 4. Data Model 


### ER Structure

<img width="695" height="667" alt="image" src="https://github.com/user-attachments/assets/a2fa2d45-5c8c-4871-bcf7-87d9ae4b282a" />


## 5. Key Design Decisions

### Managed services over self hosted

Reason: team size is small, and speed is critical. AWS managed services reduce operational overhead.

### RDS over DynamoDB

Reason: threads and annotations are relational, and query patterns are predictable.

### CDN + S3 rather than in app delivery

Reason: images will be large; CDN reduces backend load and improves user experience.


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
