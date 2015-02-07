class AsteriskController < ApplicationController

  @@ami = RubyAsterisk::AMI.new(ASTERISK_CONFIG["host"], ASTERISK_CONFIG["port"])
  @@ami.login(ASTERISK_CONFIG["username"], ASTERISK_CONFIG["password"])

  def make_call
    if session[:user_id]
      flash[:info] = @@ami.send(:execute, 'Originate', { 'Channel' => "SIP/#{session[:user_id]}",
                                          'Exten' => params["callee"],
                                          'Context' => "from-internal",
                                          'Priority' => "1",
                                          'Timeout' => '30000',
                                          'Callerid' => session[:user_id],
                                          'Async' => "true"
                                        }).success ? t("call_queued") : t("failed_to_queue_call")
    #@message="Originate successfully queued"
    else
      flash[:alert] = t("should_login_to_call")
    end
    redirect_to root_path
  end
end