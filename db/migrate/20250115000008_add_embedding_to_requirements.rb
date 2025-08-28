class AddEmbeddingToRequirements < ActiveRecord::Migration[8.0]
  def change
    # For MySQL: use TEXT to store JSON representation of the embedding vector
    # For PostgreSQL: you could use jsonb or real[] for better performance
    add_column :requirements, :embedding, :text
    
    # Add an index for better query performance when searching by embeddings
    add_index :requirements, :embedding, length: 100
  end
end
