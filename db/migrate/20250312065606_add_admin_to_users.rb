class AddAdminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :admin, :boolean, default: false
    #　引数にdefault: falseを追加することで、特別指定しない限り全てのユーザは
    # falseとなる。指定しない場合は、nilとなるためfalseと同じ意味だが、
    # コードの意図をrailsと開発者により明確に示せるようになる。

    # またこのカラムを追加することで、admin?という論理値を返すメソッドが使えるようになる
  end
end
