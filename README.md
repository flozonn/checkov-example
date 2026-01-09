# Checkov Wildcard Policy Detection

This repository contains a GitHub Action workflow that uses Checkov to detect IAM policies containing wildcards in actions or resources, which can pose security risks.

## 🚨 What This Detects

The workflow identifies IAM policies with:
- Wildcard (`*`) in actions (e.g., `s3:*`, `ec2:*`)
- Wildcard (`*`) in resources (e.g., `Resource: "*"`)
- Overly permissive policies that grant broad access

## 📁 Files Overview

- `.github/workflows/checkov-wildcard-policy-check.yml` - Main GitHub Action workflow
- `.checkov.yml` - Checkov configuration file
- `examples/iam-policies.tf` - Example Terraform files with good and bad policies

## 🔧 How It Works

1. **Triggers**: Runs on push to main/develop branches, pull requests, or manual trigger
2. **Scans**: Uses Checkov to analyze Terraform files for IAM policy violations
3. **Detects**: Identifies specific wildcard usage patterns
4. **Reports**: Comments on PRs with detailed violation information
5. **Fails**: Stops the workflow if violations are found

## 🎯 Detected Check IDs

- `CKV_AWS_60` - IAM policy should not have * resource
- `CKV_AWS_61` - IAM policy should not have * action
- `CKV_AWS_62` - IAM role should not have * in trust policy
- `CKV_AWS_63` - IAM policy attached to user/group/role should not have * action
- `CKV_AWS_40` - IAM policy should not have * resource with PassRole action
- `CKV_AWS_39` - IAM policy should not have * action and * resource

## 🚀 Usage

### Automatic Scanning
The workflow runs automatically on:
- Push to `main` or `develop` branches
- Pull requests to `main` branch

### Manual Scanning
You can trigger the workflow manually:
1. Go to the "Actions" tab in your GitHub repository
2. Select "Checkov Wildcard Policy Detection"
3. Click "Run workflow"

### Local Testing
To test locally before committing:

```bash
# Install Checkov
pip install checkov

# Run the scan
checkov -d . --framework terraform --check CKV_AWS_60,CKV_AWS_61,CKV_AWS_62,CKV_AWS_63

# Run with custom configuration
checkov -d . --config-file .checkov.yml
```

## 📊 Example Output

When violations are found, you'll see:

```
🚨 **Wildcard Policy Violations Detected** 🚨

- **File**: `examples/iam-policies.tf`
  **Check**: CKV_AWS_61 - IAM policy should not have * action
  **Resource**: `aws_iam_policy.bad_wildcard_actions`
  **Guideline**: Ensure IAM policy does not grant '*' permissions

- **File**: `examples/iam-policies.tf`
  **Check**: CKV_AWS_60 - IAM policy should not have * resource
  **Resource**: `aws_iam_policy.bad_wildcard_resources`
  **Guideline**: Ensure IAM policy does not grant '*' resource permissions
```

## 🛠 Customization

### Adding More Checks
Edit `.checkov.yml` to include additional check IDs:

```yaml
check:
  - CKV_AWS_60
  - CKV_AWS_61
  - CKV_YOUR_CUSTOM_CHECK
```

### Excluding Files
Add paths to skip in `.checkov.yml`:

```yaml
skip-path:
  - .git/
  - .terraform/
  - legacy/
```

### Custom Policies
Checkov's built-in policies are comprehensive for wildcard detection. If you need additional custom checks, you can add Python policies in a `.checkov/` directory.

## 🔒 Security Benefits

- **Principle of Least Privilege**: Enforces specific permissions instead of broad access
- **Attack Surface Reduction**: Limits potential damage from compromised credentials
- **Compliance**: Helps meet security standards and audit requirements
- **Early Detection**: Catches issues before they reach production

## 🤝 Contributing

1. Test your changes with the example policies
2. Ensure the workflow passes with good policies
3. Verify it fails with bad policies
4. Update documentation as needed

## 📚 Resources

- [Checkov Documentation](https://www.checkov.io/)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)