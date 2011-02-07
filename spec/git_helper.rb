require 'grit'

# Expects /tmp/repo
def create_repo(path)
  repo = Grit::Repo.init(path)
end

def create_tag(path, tag, sha)
  Dir.chdir(path) do
    `git tag #{tag} #{sha}`
  end
end

def create_branch(path, branch, sha)
  Dir.chdir(path) do
    `git branch #{branch} #{sha}`
  end
end

def checkout_branch(path, branch)
  Dir.chdir(path) do
    `git checkout #{branch} &>/dev/null`
  end
end

def create_commit(repo, path, file)
  Dir.chdir(path) do
    FileUtils.touch(file)
    repo.add('.')
    repo.commit_all("Adding #{file}")
  end
  repo.head.commit.id
end

