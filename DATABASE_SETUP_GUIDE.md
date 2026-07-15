# Football App Database Setup Guide

This guide will walk you through setting up your database step-by-step. **You don't need to write code** - just follow these instructions exactly.

---

## Step 1: Create a Supabase Account

**What is Supabase?** It's a database service that will store all your football data (leagues, clubs, players, matches, etc.).

### Actions You Need to Take:

1. Go to [https://supabase.com](https://supabase.com)
2. Click **"Start your project"** or **"Sign Up"**
3. Sign up using:
   - GitHub (recommended - click the GitHub button)
   - Or Email + Password
4. **Verify your email** if you chose email signup
5. You'll be taken to your dashboard

**Save this information somewhere safe (notepad/password manager):**
- Your Supabase username/email
- Your password (if you created one)

---

## Step 2: Create a New Project in Supabase

### Actions You Need to Take:

1. In the Supabase dashboard, click **"New Project"** or the **"+"** button
2. Choose a project name: `ThreeFourThree` (or your app name)
3. Create a strong password for the database (save this!)
4. Choose a region closest to you (e.g., Europe, North America, Asia)
5. Click **"Create new project"**
6. **Wait 2-3 minutes** for it to set up (you'll see a loading screen)

Once it's done, you'll see a dashboard with project information.

---

## Step 3: Connect Your Database Schema

The database structure (tables, fields) is already created in your GitHub repository. Now you need to run it in Supabase.

### Actions You Need to Take:

1. In Supabase, on the left sidebar, click **"SQL Editor"** (looks like a square with `<>`inside)
2. Click the **"New Query"** button (top left)
3. A blank text editor will appear
4. Go to your GitHub repository: [ThreeFourThree/database/schema.sql](https://github.com/JackAFC/ThreeFourThree/blob/main/database/schema.sql)
5. Click the **"Copy"** button (top right of the code)
6. Return to Supabase and **paste the code** into the SQL Editor
7. Click the **"Run"** button (or press `Ctrl+Enter` / `Cmd+Enter`)
8. **Wait for it to complete** - you should see a success message at the bottom

✅ **Your database structure is now created!**

---

## Step 4: Add Reference Data (Countries & Positions)

Your database is empty. You need to add the basic data that everything else depends on: countries and player positions.

### Actions You Need to Take:

1. In Supabase, click **"SQL Editor"** again
2. Click **"New Query"**
3. Paste this code:

```sql
-- Add countries
INSERT INTO countries (code, name, flag_emoji) VALUES
('GB', 'England', '🏴󠁧󠁢󠁥󠁮󠁧󠁿'),
('ES', 'Spain', '🇪🇸'),
('IT', 'Italy', '🇮🇹'),
('DE', 'Germany', '🇩🇪'),
('FR', 'France', '🇫🇷'),
('PT', 'Portugal', '🇵🇹'),
('NL', 'Netherlands', '🇳🇱'),
('BE', 'Belgium', '🇧🇪'),
('PL', 'Poland', '🇵🇱'),
('UA', 'Ukraine', '🇺🇦'),
('BR', 'Brazil', '🇧🇷'),
('AR', 'Argentina', '🇦🇷'),
('MX', 'Mexico', '🇲🇽'),
('US', 'United States', '🇺🇸'),
('JP', 'Japan', '🇯🇵'),
('KR', 'South Korea', '🇰🇷'),
('AU', 'Australia', '🇦🇺'),
('ZA', 'South Africa', '🇿🇦');

-- Add positions
INSERT INTO positions (code, name, category) VALUES
('GK', 'Goalkeeper', 'goalkeeper'),
('CB', 'Center Back', 'defender'),
('LB', 'Left Back', 'defender'),
('RB', 'Right Back', 'defender'),
('LWB', 'Left Wing Back', 'defender'),
('RWB', 'Right Wing Back', 'defender'),
('CDM', 'Defensive Midfielder', 'midfielder'),
('CM', 'Central Midfielder', 'midfielder'),
('CAM', 'Attacking Midfielder', 'midfielder'),
('LM', 'Left Midfielder', 'midfielder'),
('RM', 'Right Midfielder', 'midfielder'),
('LW', 'Left Winger', 'forward'),
('RW', 'Right Winger', 'forward'),
('ST', 'Striker', 'forward'),
('CF', 'Center Forward', 'forward');
```

4. Click **"Run"**
5. You should see "✓ Success" at the bottom

✅ **Your reference data is now loaded!**

---

## Step 5: Get Your Connection Details

Your app needs to know how to connect to your database. Supabase provides special connection details.

### Actions You Need to Take:

1. In Supabase, go to **Settings** (bottom left, click the gear icon ⚙️)
2. Click **"Database"** in the left menu
3. You'll see a section called **"Connection info"**
4. Look for these items and **save them in a text file or notepad**:

   - **Host** (looks like `db.xxx.supabase.co`)
   - **Database** (usually `postgres`)
   - **User** (usually `postgres`)
   - **Password** (this is the password you created in Step 2)
   - **Port** (usually `5432`)

5. Also get your **API Keys**:
   - Click **"API"** in the left sidebar
   - Copy these and save them:
     - **Project URL** (looks like `https://xxx.supabase.co`)
     - **anon public key** (long string starting with `eyJ...`)
     - **service_role secret** (another long string - keep this private!)

⚠️ **Keep these details private and secure. Don't share them publicly.**

---

## Step 6: Set Up Your Next.js App to Use the Database

Your app needs code to communicate with the database. I'll add this for you.

**What you need to do:** When you're ready, I'll create the necessary configuration files. You just need to:

1. Have these keys from Step 5 ready
2. Let me know when you're ready to proceed

---

## Step 7: Test the Database

Once everything is connected, we'll verify that the database is working properly.

**We'll do this together** - I'll create test code and walk you through running it.

---

## Troubleshooting

### **"I can't see the SQL Editor"**
- Make sure you're logged into Supabase
- Click the project name at the top - this opens your project dashboard
- Look for "SQL Editor" on the left sidebar

### **"The code didn't run / I see an error"**
- Copy the code exactly as shown
- Make sure you pasted ALL of it
- Check if there's an error message at the bottom
- Screenshot it and show me

### **"I forgot my database password"**
- In Supabase, go to Settings → Database
- Click "Reset password" 
- Set a new password and save it

### **"Where do I find my API keys?"**
- Settings (gear icon) → API in the left menu

---

## What Happens Next?

Once you complete these steps:

1. ✅ Your database is set up and ready
2. ✅ It contains the structure for 1000+ players, clubs, leagues, and tournaments
3. ✅ You have connection details to link your app

Then we'll:
1. Create a `.env` file to securely store your credentials
2. Set up your Next.js app to communicate with the database
3. Build the first pages of your app

---

## Questions?

Take screenshots of any errors and send them over. I'll help you troubleshoot!

**Ready to start? Go to Step 1: Create a Supabase Account**
