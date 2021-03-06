class ModifyConfig
  include Cinch::Plugin

  match /changeownerhost (.+) (.+)/, method: :changeit
  match /configure (.+) (.+)/, method: :config
  match /addowner (.+) (.+)/, method: :addowner

  def changeit(m, pass, hostto)
    if pass == CONFIG['modifypass']
      CONFIG['ownerhost'] = hostto.to_s
      File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
      m.reply 'Modified Hostname successfully! Run `!restart restartonly` to put changes into action!'
    else
      m.reply 'Incorrect Password!'
    end
  end

  def config(m, pass, option)
    if pass == CONFIG['modifypass']
      if option == 'ownerhost'
        CONFIG['ownerhost'] = m.user.host.to_s
        File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
        m.reply 'Your Ownerhost has been set to your current host! Run `!restart restartonly` to put changes into action!'
      end
    else
      m.reply 'Incorrect Password!'
    end
  end

  def addowner(m, pass, owner)
    if pass == CONFIG['modifypass']
      CONFIG['ownerhost'] = "#{CONFIG['ownerhost']} || #{m.user.host}"
      File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
      m.reply "Added `#{owner}` to the list of owners! Run `!restart restartonly` to put changes into action!"
    else
      m.reply 'Incorrect Password!'
    end
  end
end
