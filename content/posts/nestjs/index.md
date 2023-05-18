---
title: NestJS
date: 2023-05-02
tags: [linux, web development]
---

## Using validation rules in DTOs

Using `class-validator` decorators in your DTOs is not strictly necessary, but it's recommended when working with NestJS because it allows you to validate incoming data at the application layer before it reaches your Mongoose schema.

NestJS and Mongoose schema validation serve different purposes:

DTO validation (class-validator): Validates the data coming from the client or other external sources before it reaches your application's business logic. This can help you catch issues early on, before any processing or storage happens. NestJS's validation pipes make it easy to automatically validate incoming request payloads against DTOs.

Mongoose schema validation: Validates the data before it's saved to the database. While this is useful as a final check to ensure data integrity, it doesn't provide the same level of control and error handling as NestJS's validation pipes with DTOs.

Using both DTO validation and Mongoose schema validation can provide multiple layers of validation, which can help ensure that your application receives valid data and stores it correctly. However, it is possible to rely only on Mongoose schema validation if you are willing to handle validation errors at the database layer.

In summary, while you don't strictly need class-validator decorators in your NestJS DTOs, it's generally a good idea to use them alongside Mongoose schema validations to provide better control over incoming data and error handling.
