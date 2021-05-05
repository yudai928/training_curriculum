class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)
    # 今日から1週間 = plans

    #     # 配列plansの中身はこのような状態。
#     # [#<Plan:0x00007fdf5c18b378 id: 14, plan: "遊びに行く", date: Sun, 17 Jan 2021, created_at: Tue, 12 Jan 2021 15:01:37 UTC +00:00, updated_at: Tue, 12 Jan 2021 15:01:37 UTC +00:00>,
#     #<Plan:0x00007fdf5c91cb50 id: 16, plan: "やっぱりいかない", date: Sun, 17 Jan 2021, created_at: Tue, 12 Jan 2021 15:11:53 UTC +00:00, updated_at: Tue, 12 Jan 2021 15:11:53 UTC +00:00>,
#     #<Plan:0x00007fdf5c91ca88 id: 17, plan: "この日に遊ぶ", date: Mon, 18 Jan 2021, created_at: Tue, 12 Jan 2021 15:12:05 UTC +00:00, updated_at: Tue, 12 Jan 2021 15:12:05 UTC +00:00>]

    7.times do |x|
      today_plans = [] #7回eachされた事で、1週間分の予定が入っている
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = today_plans[x]
      if wday_num.to_i >= 7
        wday_num = wday_num -7
      end

      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, wday: wdays[x]}
      @week_days.push(days)
    end
  end
  end

