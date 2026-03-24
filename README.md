# StackFlow VA 💼
### The Purpose Metrics Tool-Discovery Engine

> Eliminate tool overload. Get your personalised Virtual Assistant toolkit in seconds.

StackFlow VA is a full-stack Ruby on Rails web application designed for Virtual Assistants and remote workers. It solves one of the biggest pain points for new VAs — **analysis paralysis** — by taking two simple inputs (your niche and your budget) and returning a curated, research-backed Day-1 tool stack instantly.

[![Ruby](https://img.shields.io/badge/Ruby-3.3.6-red)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.1.2-red)](https://rubyonrails.org/)
[![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE)

---

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Code Structure](#code-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [VA Niches Supported](#va-niches-supported)
- [Budget Tiers](#budget-tiers)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Two-tier niche classification** — Generalist VAs (entry level) and Specialist VAs (higher earning)
- **Smart budget filtering** — Three tiers: free only ($0), starter + upgrade ($1–$49), full stack ($50+)
- **Research-backed tool stacks** — Every recommendation is based on real 2025/2026 VA industry data
- **Profile persistence** — All VA profiles saved to SQLite3 database for future reference
- **Model-level validation** — Prevents invalid niche submissions and negative budgets
- **Service object architecture** — Clean, testable, maintainable Rails code structure
- **YAML-driven tool data** — Tool stacks stored in config files, easy to update without touching code
- **Free/Paid badges** — Clear visual indicators on every tool recommendation

---

## Technologies Used

| Technology | Version | Purpose |
|---|---|---|
| Ruby | 3.3.6 | Programming language |
| Rails | 8.1.2 | Full-stack web framework |
| SQLite3 | Latest | Development database |
| Puma | 7.2.0 | Web server |
| ERB | Built-in | HTML templating |
| RuboCop | Latest | Code style enforcement |
| Brakeman | Latest | Security scanning |
| WSL2 + Ubuntu 24.04 | — | Development environment (Windows) |

---

## Code Structure

```
stackflow-va/
├── app/
│   ├── controllers/
│   │   └── va_profiles_controller.rb   # Thin controller — delegates to service
│   ├── models/
│   │   └── va_profile.rb               # Validates niche and budget
│   ├── services/
│   │   └── tool_recommender.rb         # Core recommendation logic (service object)
│   └── views/
│       └── va_profiles/
│           ├── _form.html.erb          # Niche dropdown + budget input
│           ├── new.html.erb            # Form page
│           └── show.html.erb          # Results page with tool stack
├── config/
│   └── va_tools.yml                    # All tool data — edit here to add/remove tools
├── db/
│   ├── migrate/                        # Database migrations
│   └── schema.rb                       # Current database schema
├── test/
│   ├── controllers/                    # Controller tests
│   ├── fixtures/
│   │   └── va_profiles.yml             # Test data fixtures
│   └── models/                         # Model tests
└── README.md
```

---

## Prerequisites

Before you begin, ensure you have the following installed:

- **Windows 10/11** with WSL2 enabled (Ubuntu 24.04 recommended)
- **Ruby 3.3.6** (via rbenv)
- **Rails 8.1.2**
- **SQLite3**
- **Git**
- **VS Code** with the WSL extension (recommended)

> **Windows users:** This project was developed using WSL2. Do not use the Docker Desktop WSL environment — install Ubuntu 24.04 separately from the Microsoft Store.

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/kimkojosephine-crypto/stackflow-va.git
cd stackflow-va
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Set up the database

```bash
rails db:migrate
```

### 4. Start the server

```bash
rails server
```

### 5. Open in your browser

```
http://localhost:3000/va_profiles/new
```

---

## Usage

### Generating a tool stack

1. Visit `http://localhost:3000/va_profiles/new`
2. Select your **VA niche** from the dropdown (see [VA Niches Supported](#va-niches-supported))
3. Enter your **monthly tool budget** in USD
4. Click **"Generate My Stack →"**
5. View your personalised tool recommendations with Free/Paid badges

### Viewing saved profiles

Visit `http://localhost:3000/va_profiles` to see all previously generated profiles.

### Example output

For a **General VA** with a **$25/month** budget:

```
✓ Trello          — Visual task & project management        [Free]
✓ Calendly        — Automated meeting scheduling            [Free]
✓ Notion          — All-in-one notes, docs & wikis          [Free]
✓ LastPass        — Secure password management              [Free]
★ Google Workspace — Email, Docs, Drive & Calendar suite ⭐ [Paid — Recommended upgrade]
```

---

## Configuration

### Adding or updating tools

All tool data lives in `config/va_tools.yml`. To add a new tool to a niche:

```yaml
General VA:
  - name: Your New Tool
    desc: Brief description of what it does
    free: true   # true = free tier available, false = paid only
```

### Adding a new niche

1. Add the niche and its tools to `config/va_tools.yml`
2. Add the niche string to `VALID_NICHES` in `app/models/va_profile.rb`
3. Add the niche option to the dropdown in `app/views/va_profiles/_form.html.erb`

### Budget tier thresholds

Budget thresholds are defined in `app/services/tool_recommender.rb`:

```ruby
when 50..Float::INFINITY  # Full stack
when 1..49                # Free + one paid upgrade
else                      # Free tools only
```

Adjust the `50` threshold to change when the full stack unlocks.

---

## VA Niches Supported

### Tier 1 — Generalist VAs
| Niche | Focus | Starting Rate |
|---|---|---|
| General VA | Administrative & Executive Support | $10–25/hr |
| Travel & Itinerary VA | Trip Planning & Bookings | $15–30/hr |

### Tier 2 — Specialist VAs
| Niche | Focus | Starting Rate |
|---|---|---|
| Creative VA | Content, Design & Brand Support | $20–40/hr |
| Social Media VA | Digital Presence & Community Management | $20–45/hr |
| Lead Gen VA | Sales Pipeline & Business Development | $25–50/hr |
| Real Estate VA | Property Operations & Transactions | $25–55/hr |
| Tech VA | AI, Automation & Systems Specialist | $40–80/hr |

> **Pro tip:** Start as a General VA to build client experience, then niche up into Tech or Lead Gen within 6–12 months for higher rates.

---

## Budget Tiers

| Budget | What you get |
|---|---|
| $0 | Free tools only — maximum accessibility for new VAs |
| $1 – $49 | Free tools + one paid upgrade suggestion marked with ⭐ |
| $50+ | Full stack including all premium paid tools |

---

## Troubleshooting

### `rails: command not found` after installing Rails
```bash
rbenv rehash
rails -v
```

### `A server is already running`
```bash
rm tmp/pids/server.pid
rails server
```

### `No such file or directory — config/va_tools.yml`
The YAML tool data file is missing. Re-create it:
```bash
# See config/va_tools.yml in the repository for full contents
touch config/va_tools.yml
```

### `SQLite3::Exception: no such table: va_profiles`
Run the database migration:
```bash
rails db:migrate
```

### RuboCop errors on push
Let RuboCop auto-fix its own violations:
```bash
bin/rubocop --autocorrect
```

### WSL2 showing Docker Desktop instead of Ubuntu
You are in the wrong WSL environment. Open Ubuntu 24.04 from the Windows Start menu instead of using the Docker terminal.

---

## Contributing

Contributions are welcome! Here's how to get started:

1. Fork the repository
2. Create a feature branch
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes following Rails conventions
4. Run the test suite
   ```bash
   rails test
   ```
5. Run RuboCop to check code style
   ```bash
   bin/rubocop
   ```
6. Commit your changes
   ```bash
   git commit -m "Add: brief description of your change"
   ```
7. Push and open a Pull Request

### Ideas for contributions
- Add new VA niches (e.g. Bookkeeping VA, E-commerce VA)
- Add tool pricing information
- Add links to each tool's website on the results page
- Add user authentication so VAs can save multiple profiles
- Add a comparison view between two niches

---

## License

This project is licensed under the MIT License.

---

## Author

**Josephine Kimko**
Moringa School Capstone Project — 2026
GitHub: [@kimkojosephine-crypto](https://github.com/kimkojosephine-crypto)

---

*Built with Ruby on Rails as part of the Moringa School Software Development curriculum.*