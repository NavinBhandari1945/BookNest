using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace BookNest.Migrations
{
    /// <inheritdoc />
    public partial class m3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "BookmarkInfos",
                columns: table => new
                {
                    BookmarkId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    BookId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BookmarkInfos", x => x.BookmarkId);
                    table.ForeignKey(
                        name: "FK_BookmarkInfos_BookInfos_BookId",
                        column: x => x.BookId,
                        principalTable: "BookInfos",
                        principalColumn: "BookId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BookmarkInfos_UserInfos_UserId",
                        column: x => x.UserId,
                        principalTable: "UserInfos",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "CartInfos",
                columns: table => new
                {
                    CartId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    AddedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    Quantity = table.Column<int>(type: "integer", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    BookId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CartInfos", x => x.CartId);
                    table.ForeignKey(
                        name: "FK_CartInfos_BookInfos_BookId",
                        column: x => x.BookId,
                        principalTable: "BookInfos",
                        principalColumn: "BookId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CartInfos_UserInfos_UserId",
                        column: x => x.UserId,
                        principalTable: "UserInfos",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "OrderInfos",
                columns: table => new
                {
                    OrderId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Status = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    BookQuantity = table.Column<int>(type: "integer", nullable: false),
                    ClaimId = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    DiscountAmount = table.Column<int>(type: "integer", nullable: false),
                    TotalPrice = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    ClaimCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    OrderDate = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    BookId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OrderInfos", x => x.OrderId);
                    table.ForeignKey(
                        name: "FK_OrderInfos_BookInfos_BookId",
                        column: x => x.BookId,
                        principalTable: "BookInfos",
                        principalColumn: "BookId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_OrderInfos_UserInfos_UserId",
                        column: x => x.UserId,
                        principalTable: "UserInfos",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BookmarkInfos_BookId",
                table: "BookmarkInfos",
                column: "BookId");

            migrationBuilder.CreateIndex(
                name: "IX_BookmarkInfos_UserId",
                table: "BookmarkInfos",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_CartInfos_BookId",
                table: "CartInfos",
                column: "BookId");

            migrationBuilder.CreateIndex(
                name: "IX_CartInfos_UserId",
                table: "CartInfos",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderInfos_BookId",
                table: "OrderInfos",
                column: "BookId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderInfos_UserId",
                table: "OrderInfos",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BookmarkInfos");

            migrationBuilder.DropTable(
                name: "CartInfos");

            migrationBuilder.DropTable(
                name: "OrderInfos");
        }
    }
}
