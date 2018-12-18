# Changelog

## 0.7.0

- Switched to using `PAY_PER_REQUEST` for all DynamoDB tables and removed autoscaling;
- Users **must** remove the `min_capacity` input variable, if provided;

## 0.6.0

- `region` is now a required input for `geopoiesis-backend`;
