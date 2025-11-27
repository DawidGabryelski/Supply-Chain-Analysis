# Project: Analyzing Logistics Partner Performance


## Overview

The **Supply Chain** is the critical element ensuring well-functioning **logistics processes** across various industries. Every link in the chain—from the delivery of raw materials or components to the final customer—must **cooperate effectively** to provide the best possible products or services. 



This project focuses specifically on the performance of **Logistics Partners (Couriers)**, who are responsible for transporting goods between sequential representatives of the supply chain (e.g., suppliers, manufacturers, distribution centers).

Based on the available dataset, we will leverage **SQL** to conduct a comprehensive analysis of courier companies, specifically evaluating their performance concerning **timeliness (On-Time Delivery)**, reliability, and exposure to **operational risk**. This analysis aims to identify high-performing and high-risk partners.



## Business Problem: Logistics Performance Management

Substandard service quality provided by logistics partners, often manifesting as frequent delivery delays, leads to disruptions in production planning, increased operational costs, and diminished customer satisfaction. Without an objective, data-driven evaluation, the company cannot accurately measure which partner delivers the most value and which constitutes a bottleneck within the supply chain.



## Methodology

The methodology was based on a sequential analysis of performance, external factors, and temporal trends, executed in the following phases:

#### Phase I: Preliminary Time Analysis and KPI Definition

1. Metric Preparation: A CTE (timeliness_analysis) was created to calculate fundamental delivery time metrics: the expected duration and the actual order fulfillment time (in days) using the DATEDIFF function.

2. OTD Establishment: The key performance indicator On-Time Delivery (OTD) was defined by calculating the overall delivery reliability (the percentage of shipments delivered on or before the expected date) and the associated delay rate.

#### Phase II: Logistics Partner Performance Evaluation and Ranking

1. Performance Aggregation: Leveraging the initial CTEs, the OTD Rate for each Logistics Partner was calculated as the percentage of shipments completed on time.

2. Multifactor Evaluation: Timeliness metrics were combined with service quality data (average supplier_rating) and the average delay (in days). This phase allowed for objective comparison of partners and the identification of potential bottlenecks.

#### Phase III: Analysis of External Factor Influence

1. Weather-Status Correlation: The relationship between environmental factors (weather_condition) and shipment status (shipment_status) was examined. This aggregation provided insights into which shipment status (e.g., delayed, in-transit) occurs most frequently under specific weather conditions (e.g., rainy, sunny).

#### Phase IV: Volume Analysis and Time-Series Trends

1. Trend Detection: An analysis was conducted to aggregate the daily order volume over time (by casting the timestamp to date). The objective was to detect any seasonality, cyclicality, or significant anomalies in transportation volume, which is essential for resource optimization.


## Results and Business Interpretation

Based on the performed SQL analysis, key performance indicators of logistics partners, as well as temporal and environmental patterns impacting delivery timeliness, have been identified.

#### Logistics Performance and Partner Ranking (Phase I & II)

The analysis revealed significant differences in the service quality provided by partners, with On-Time Delivery (OTD) serving as the primary differentiator.

1. Overall System Reliability: The overall OTD rate across all shipments was 0.70. This means that 0.30  of shipments arrived after the expected due date.
2. Key Players and Bottlenecks: The ranking of logistics partners (derived from the logistic_partner_delivery_stats CTE) showed that the partners had similar score of the OTD rate between 0.67 and 0.73. 

