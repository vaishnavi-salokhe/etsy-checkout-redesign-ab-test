# Etsy Checkout Redesign A/B Test Analysis

## Project Overview
This project evaluates an e-commerce checkout redesign using A/B testing data. The analysis compares a control group using the existing checkout experience with a treatment group exposed to the redesigned checkout experience.

The objective is to assess whether the redesign is associated with improved conversion performance and to explore how results vary by device, visitor type, and date.

## Business Objectives
- Compare conversion rates between control and treatment groups.
- Calculate the relative conversion lift associated with the redesign.
- Examine performance across device categories.
- Compare results by visitor type.
- Track daily conversion trends.
- Present experiment results through an Excel dashboard.

## Tools & Technologies
- **MySQL:** Data querying, aggregation, and experiment analysis.
- **Microsoft Excel:** KPI cards, charts, and dashboard creation.
- **SQL:** Data quality checks, conversion calculations, segmentation, and trend analysis.

## Dataset
The project uses two datasets:

- **Assignments:** User IDs, assigned experiment variants, assignment timestamps, device categories, and visitor types.
- **Orders:** Order IDs, user IDs, order timestamps, and order values.

The experiment uses two variants: `control` and `treatment`.

## Key Performance Indicators
- Total users assigned
- Control conversion rate
- Treatment conversion rate
- Relative conversion lift

## Analysis Performed
1. Assignment data quality assessment.
2. Order data quality assessment.
3. Overall experiment performance comparison.
4. Conversion performance by device.
5. Conversion performance by visitor type.
6. Daily conversion trend analysis.
7. Relative conversion lift calculation.

## Initial Findings
The assignment dataset contains **31,284 assignment records** and **31,000 unique users**, so some users have multiple assignment records and should be considered carefully when interpreting experiment results.

The dashboard displays a control conversion rate of **7.51%** and a treatment conversion rate of **7.93%**. Based on these displayed rates, the treatment group has an approximate **5.59% relative conversion lift**.

This is a descriptive comparison. Statistical significance and experiment validity should be evaluated before concluding that the redesign caused a genuine improvement.

## Dashboard
The Excel dashboard includes:
- Total users assigned
- Control conversion rate
- Treatment conversion rate
- Relative conversion lift
- Conversion rate comparison by variant
- Daily conversion trend

## Business Recommendations
- Validate experiment assignment consistency and investigate repeated assignments.
- Evaluate conversion performance across device categories.
- Compare new and returning visitor behavior.
- Assess statistical significance and experiment validity before rolling out the redesign.
- Monitor conversion and order-value metrics after any product changes.
- Use the results alongside customer experience and checkout usability feedback.

## Project Structure
- `Etsy_Checkout_Redesign_AB_Test.sql` — SQL queries used for analysis.
- `Etsy_Checkout_Redesign_AB_Test.xlsx` — Excel dashboard and supporting analysis.
- `01_assignments_data_quality.csv` to `07_conversion_lift.csv` — Saved SQL query results.
- `assignments.csv` — Experiment assignment dataset.
- `orders.csv` — Order dataset.

## Conclusion
This project demonstrates how SQL and Excel can be used to evaluate an e-commerce experiment, compare conversion performance, investigate user segments, and translate experiment metrics into business recommendations.

**Skills Demonstrated:** SQL, A/B testing, conversion rate analysis, experimentation metrics, data quality assessment, segmentation analysis, Excel dashboards, and business decision support.
