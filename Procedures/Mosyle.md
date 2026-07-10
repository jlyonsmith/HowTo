
## Native Account Management

You perform native account management in Mosyle by deploying explicit payloads found under the **Management** tab. Instead of relying on a cloud provider, Mosyle interacts directly with Apple’s native Open Directory framework to create, secure, and monitor accounts.

### Step 1: Deploy a Dedicated MDM Admin Account

Always create a hidden or visible master administrator account during deployment. This ensures you never lose access to the computer.

1. Log into your [Mosyle Portal](https://business.mosyle.com/).
2. Navigate to **Management** > **Automated Device Enrollment** (under the Setup Assistant section).
3. Click your active enrollment profile.
4. Locate the **Account Settings** tab.
5. Choose to **Create an additional administrator account**.
6. Input a universal username (e.g., `localadmin`) and a highly secure password.
7. Check **Hide account** if you do not want end-users to see it at the login window. 

Step 2: Provision Local End-User Accounts

For the actual employees or students, you can configure how their primary accounts behave when they turn on a fresh machine.

1. In the same **Automated Device Enrollment** profile, go to the **User Account Type** section.
2. Select **Standard** (Highly recommended for security) or **Administrator**.
3. If you want the user to choose their own username and password during the initial Mac Setup Assistant, choose **Custom Setup**.
4. Save the profile. When the Mac goes through Apple Zero-Touch deployment, it will automatically build these exact account types.

Step 3: Enforce Native Security and Password Policies

To force compliance on these local accounts without an SSO, you must push a restrictions profile.

1. Go to **Management** > **Profiles** > **Add new profile**. [[1](https://help.progresslearning.com/article/y0k00tsbhp-how-to-set-up-a-lockdown-browser-on-i-pads-using-mosyle-mdm)]
2. Select **Passcode** from the profile list.
3. Configure your local security constraints:
    - **Minimum passcode length** (e.g., 8 or 12 characters).
    - **Passcode policy** (Require alphanumeric, symbols, or capitals).
    - **Maximum passcode age** (Forces local password expiration every X days). [[1](https://www.lifewire.com/administrative-tools-2625804), [2](https://docs.elementum.io/administration/sso-saml-setup), [3](https://learn.microsoft.com/en-us/intune/fundamentals/ref-policy-map-access-requirements), [4](https://www.lifewire.com/administrative-tools-2625804)]
4. Assign this profile to your device group and click **Save**. The Mac will immediately prompt local users to change passwords if they don't meet the new rules. [[1](https://classroom.cloud/pdfs/cc_deploying_the_mac_student_using_Mosyle.pdf)]

Step 4: Configure Admin On-Demand (Eliminate Full-Time Admins)

Because you configured end-users as **Standard** users in Step 2, they cannot install software or alter system networks. You can use **Admin On-Demand** to give them temporary access. [[1](https://moundspark.zendesk.com/hc/en-us/articles/43238874966547-Using-Admin-On-Demand-in-Mosyle)]

1. Go to **Management** > **Admin On-Demand**.
2. Click **Add new profile**.
3. Toggle the feature **On** and define the maximum duration allowed (e.g., 5 minutes or 15 minutes).
4. Save and assign to your Macs.
5. **How it looks for the user:** The user opens the **Mosyle Manager app** in their macOS applications folder, clicks **Admin On-Demand**, and requests access. They are instantly granted temporary admin rights which automatically revoke when the timer expires. [, [2](https://support.google.com/chrome/a/answer/12818048?hl=en_PK), [3](https://support.everlaw.com/hc/en-us/articles/29736853152411-Manage-and-Track-Everlaw-AI-Credit-and-Feature-Use), [4](https://www.reddit.com/r/mosyle/comments/1kkwsly/admin_password_requirement/), [5](https://www.reddit.com/r/mosyle/comments/16mzljn/first_mac_login_with_m365_sso_you_are_not_allowed/)]