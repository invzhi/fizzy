# Run using bin/ci

require_relative "../lib/fizzy"

OSS_ENV = "SAAS=false BUNDLE_GEMFILE=Gemfile"
SAAS_ENV = "SAAS=true BUNDLE_GEMFILE=Gemfile.saas"

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Style: Ruby", "bin/rubocop"

  step "Security: Gem audit", "bin/bundler-audit check --update"
  step "Security: Importmap audit", "bin/importmap audit"
  step "Security: Brakeman audit", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"
  step "Security: Gitleaks audit", "bin/gitleaks-audit"

  if Fizzy.saas?
    step "Tests: SaaS", "#{SAAS_ENV} bin/rails test:all"
    step "Tests: SQLite", "#{OSS_ENV} DATABASE_ADAPTER=sqlite bin/rails test:all"
  else
    step "Tests: MySQL", "#{OSS_ENV} DATABASE_ADAPTER=mysql bin/rails test:all"
    step "Tests: SQLite", "#{OSS_ENV} DATABASE_ADAPTER=sqlite bin/rails test:all"
  end

  if success?
    step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
  else
    failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
  end
end
